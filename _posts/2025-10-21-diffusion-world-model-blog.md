---
title:  "Diffusion Models: A New Playground for Reinforcement Learning"
date:   2025-10-21 10:00:00 +0000
show_toc: true
published: false
author: "Anais Cheval"
---

<!-- # Diffusion Models: A New Playground for Reinforcement Learning -->

Reinforcement learning (RL) has achieved remarkable progress in solving complex decision-making problems, from playing Go and mastering Atari games (Silver et al., 2018) to robotic control. Yet, one major limitation remains — **sample inefficiency**. RL agents often require millions of interactions with their environments to learn effective policies. In the real world, such exhaustive trial-and-error is often impractical or prohibitively time expensive.

To address this, researchers have turned to **world models** — generative models that learn to simulate environments. Instead of interacting with the real world at every step, an agent can learn by imagining outcomes within its learned world model. This idea, popularized by works like *World Models* (Ha & Schmidhuber, 2018), has inspired a line of research into using generative modeling as a core component to train RL agents.

<p align="center">
  <img src="image.png" alt="World Models" width="200">
  <br>
  <em>Figure 1: A World Model, from Scott McCloud’s <i>Understanding Comics</i>.</em>
</p>

Over time, a variety of generative modelling approaches have been explored to serve as effective world models, including **Variational Autoencoders (VAEs)**, **Generative Adversarial Networks (GANs)**, and **Flow-based models**.  

- **VAEs** are stable and easy to train but rely on a surrogate loss, which can lead to blurry reconstructions (Kingma & Welling, 2014). This can be limiting when high-fidelity state predictions are required for planning in RL.  
- **GANs** can produce highly realistic samples, but their adversarial training often leads to instability and mode collapse, resulting in limited diversity — a critical drawback when trying to capture all possible environment states (Goodfellow et al., 2014; Arjovsky & Bottou, 2017).  
- **Flow-based models** learn bijective mappings between data and latent spaces, allowing for exact likelihood estimation and stable training (Rezende & Mohamed, 2015). However, they require carefully designed architectures to maintain reversibility, which can limit flexibility and scalability in modeling complex, high-dimensional environments.

While VAEs, GANs, and flow models have all been explored as world models, each involves trade-offs that can affect their use in RL. This has led researchers to investigate **diffusion models**, a newer class of generative models with a different approach to modeling data distributions.

---

## The Basics of Diffusion Models

Diffusion models are inspired by non-equilibrium thermodynamics, where systems naturally evolve from low-entropy (ordered) states to high-entropy (disordered) states. They define a Markov chain of diffusion steps that gradually add random noise to data, mimicking the physical process of diffusion. The model then learns to reverse this process — transforming noise back into structured data — effectively moving from a high-entropy to a low-entropy state.

Through this learned denoising dynamics, diffusion models can generate realistic data samples by starting from random noise and iteratively reconstructing the underlying structure of the data distribution. Conceptually, this can be seen as an encoding–decoding process, like VAEs or flow-based models, where the forward diffusion “encodes” data into a noisy latent and the reverse process “decodes” it back into structured samples. However, unlike VAEs or flows, the forward procedure is fixed (not learned), and the latent variables have the same dimensionality as the original data rather than being compressed into a smaller latent space.

The forward and backward processes in diffusion models can be formulated in both discrete and continuous forms. We will briefly mention the discrete form as it is the original historical formulation, but our focus will be on the continuous form, which is more generic and better captures complex, high-dimensional dynamics.

In the **discrete-time formulation**, the forward process gradually adds noise to a data sample $x^0$ over $T$ timesteps, producing a sequence $\{x^1, x^2, \dots, x^T\}$.  
At each step $\tau$, noise is added according to a predefined schedule $\beta^\tau$:

<div>
$$
x^\tau = \sqrt{1 - \beta_\tau} \, x^{\tau-1} + \sqrt{\beta_\tau} \, \epsilon_\tau, \quad \epsilon_\tau \sim \mathcal{N}(0, I)
$$
</div>

The backward process learns to reverse this noising process by estimating the conditional distribution $p_\theta(x^{\tau-1} \mid x^\tau)$, typically parameterized by a neural network.

In the **continuous-time formulation**, the forward process is modeled as a stochastic differential equation (SDE), which smoothly diffuses the data into noise:


<div>
$$ dx = f(x, \tau) \, d\tau + g(\tau) \, dW_\tau $$
</div>

where $f(x, \tau)$ represents a predefined deterministic drift term, $g(\tau)$ a predefined diffusion coefficient, and $dW_\tau$ denotes a Wiener process (Brownian motion).  

The backward process then corresponds to a reverse-time SDE, which removes noise by following the time-reversed dynamics:

<div>
$$
dx = [f(x, \tau) - g(\tau)^2 \nabla_x \log p_\tau(x)] \, d\tau + g(\tau) \, d\bar{W}_\tau
$$
</div>


where $ d \bar{W}_\tau$ represents the reverse-time Wiener process and $\nabla_x \log p_\tau(x)$ the score function of the noisy distribution at time $\tau$.  

The score function $\nabla_x \log p_\tau(x)$ represents the gradient of the log-probability of the data at time $\tau$, pointing toward regions of higher likelihood. It adjusts the drift $f(x, \tau)$ in the reverse-time SDE, guiding $x$ to produce realistic samples.


Since the distribution $p_\tau(x)$ is generally unknown, the score function $\nabla_x \log p_\tau(x)$ is also unknown and must be estimated from data. Diffusion models achieve this by leveraging a combination of sampling and learning. A typical approach assumes that the deterministic shift function $f(x, \tau)$ is affine, which simplifies the mathematics and allows the forward diffusion process to reach any intermediate time $\tau$ analytically using a Gaussian perturbation kernel $p^{0}_ {\tau}(x^\tau \mid x^0)$. The procedure then proceeds as follows:

1. **Sample clean data** $x^0$ from the target distribution.  
2. **Corrupt the samples** by simulating the forward diffusion to obtain $x^\tau$ at the desired time $\tau$. If $f$ is affine, this can be done in a single step using the known Gaussian kernel.  
3. **Train a score model** $s_\theta(x, \tau)$ to estimate the score function by minimizing a denoising objective such as:

<div>
   $$
   \mathbb{E}_{x^0, x^\tau \sim p^{0}_{\tau}} \left[ \left\| s_\theta(x^\tau, \tau) - \nabla_{x^\tau} \log p^{0} _{\tau}(x^\tau \mid x^0) \right\|^2 \right]
   $$
</div>

Once trained, this score model provides an approximation of $\nabla_x \log p_\tau(x)$ at any time $\tau$, allowing the backward SDE to iteratively denoise samples and generate realistic data from pure noise.

---

## Diffusion Models for World Modelling

In the context of world modeling for sequential decision-making, the goal is to learn a generative model of the environment dynamics — that is, to predict the next state of the system given past states and actions. Formally, we aim to model a conditional generative distribution:

<div>
$$
p_\theta(x_{t+1} \mid x_{\le t}, a_{\le t}),
$$
</div>

where $x_{t+1}$ is the next (unknown) state, $x_{\le t} = \{x_0, \dots, x_t\}$ are past states, and $a_{\le t} = \{a_0, \dots, a_t\}$ are past actions. Unlike unconditional diffusion models, here the diffusion model must condition on the history of observations and actions to accurately predict the future.

**To train a diffusion model** for world modeling, we first need to collect trajectories $(x_0, a_0, x_1, a_1, \dots, x_t, a_t, x_{t+1})$ from the real environment to obtain clean next states $x_{t+1}$ as targets. Once we have these trajectories, we treat $x_{t+1}$ as the “clean” data and corrupt it with a Gaussian perturbation kernel to produce a noisy sample $x_{t+1}^\tau$. The model then learns a conditional score function $s_\theta(x_{t+1}^\tau, \tau \mid x_{\le t}, a_{\le t})$ that estimates the gradient of the log-probability of the noisy next state. The training objective is the following loss:

<div>
$$
\mathcal{L}(\theta) = \mathbb{E}_{x_{t+1}, \, x_{t+1}^\tau \sim p^0_\tau} \Big[ \| s_\theta(x_{t+1}^\tau, \tau \mid x_{\le t}, a_{\le t}) - \nabla_{x_{t+1}^\tau} \log p^0_\tau(x_{t+1}^\tau \mid x_{t+1}) \|^2 \Big],
$$
</div>

which encourages the model to reverse the corruption process and recover $x_{t+1}$ conditioned on past observations and actions.

**Once the diffusion model is trained**, it can be used as a generative model for decision-making. In this setting, the next state $x_{t+1}$ is typically unknown and is initially represented either as Gaussian noise or a prior estimate. The model then iteratively denoises this sample, step by step, using the reverse-time SDE, conditioned on past states and actions. This procedure generates a realistic prediction of the next state, which can be used to train a RL agent.

---

## Iterative Training of the Reinforcement Learning Agent and the Diffusion Model

In general, diffusion models and reinforcement learning (RL) agents are not trained fully separately but rather in an iterative loop, where both models are improved in alternating phases. The typical procedure involves three main steps:
1. **Collect real data:** The RL agent interacts with the real environment collecting trajectories of states, actions and rewards in a replay buffer.

2. **Train the world model:** A diffusion-based world model is trained using all data from the replay buffer. In addition to modeling the next state, auxiliary components such as a **reward model** and a **termination model** are included to fully capture the environment dynamics.  

3. **Train the RL agent in imagination:** Once the world model is trained, it replaces the real environment during policy optimization. The agent is trained by imagining trajectories—simulating rollouts within the learned model—using the predicted next states, rewards, and terminations.  

These three steps are **repeated in a loop**, allowing the world model to continuously refine its understanding of the environment while the RL agent progressively improves its policy through imagined experiences.

---

## A promising example


A recent paper, *Diffusion for World Modeling: Visual Details Matter in Atari* (Alonso et al., NeurIPS 2024), presents **DIAMOND**, a RL-agent trained on a diffusion-based world model that achieves impressive performance on the **Atari 100k benchmark**. This benchmark evaluates agents across 26 Atari games, where each agent is allowed only 100k real environment interactions—roughly equivalent to two hours of human gameplay—to train its world model. For context, traditional RL agents without world models are typically trained in the environment for up to 50 million steps, meaning DIAMOND needs **500× less interactions** with the environment.

DIAMOND is compared against several state-of-the-art world model agents, including **STORM** (Zhang et al., 2023), **DreamerV3** (Hafner et al., 2023), **IRIS** (Micheli et al., 2023), **TWM** (Robine et al., 2023), **IRIS** (Micheli et al., 2023), and **SimPle** (Kaiser et al., 2019). In aggregate performance, DIAMOND achieves a **superhuman mean human-normalized score (HNS) of 1.46**, outperforming all previous world model agents, and exceeding human-level performance on **11 out of 26 games**. Notably, its interquartile mean (IQM) performance matches that of STORM while surpassing all other baselines, demonstrating consistent performance across games. DIAMOND particularly excels in visually detailed environments such as *Asterix*, *Breakout*, and *Road Runner*, where precise visual modeling directly influences decision-making.

A key comparison is with **IRIS**, a world model based on a **Variational Autoencoder (VAE)** architecture. While IRIS generates plausible trajectories, they often suffer from **visual inconsistencies between consecutive frames**—for example, enemies being rendered as rewards or vice versa. Although these discrepancies may only affect a few pixels, they can drastically alter the agent’s learning process, as reward-related information is critical for policy optimization. In contrast, DIAMOND’s diffusion-based approach produces **visually consistent trajectories**, more accurately reflecting the true environment. These improvements in visual fidelity directly translate to stronger agent performance across several games.

Overall, DIAMOND provides compelling evidence that diffusion models can significantly advance world modeling for reinforcement learning, enabling more accurate, visually coherent, and data-efficient policy learning.

