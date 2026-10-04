---
title: "Scalable Multi-Agent Reinforcement Learning for Collision Avoidance"
venue: "Master's Thesis, KTH Royal Institute of Technology"
authors:
    - name: "Andreu Matoses Gimenez"
      url: "https://andreumatoses.github.io/"
affiliations:
    - name: "KTH Royal Institute of Technology, Sweden"
      url: "https://kth.se"
date: 2023-06-01
description: "Scalable multi-agent reinforcement learning for formation control with collision avoidance. This work was my Master's Thesis while at KTH Royal Institute of Technology. The proposed method exploits the reward structure to enable local approximation of Q-functions and policy gradients, allowing for scalable training. We compare discrete and continuous policies and analyze the impact of the sensing radius on performance and collision avoidance."
cover: cover.mp4
bibkey: matoses2023msc
links:
    - name: Paper
      icon: bi-file-earmark-pdf
      url: "https://kth.diva-portal.org/smash/get/diva2:1750943/FULLTEXT01.pdf"
    - name: Code
      icon: bi-github
      url: "https://github.com/AndreuMatoses/scalable-collision-avoidance-RL"
gallery_agents:
  - formation_n10.mp4
  - formation_n5.mp4
---

{% include "partials/gallery.liquid", items: gallery_agents, columns: 2, caption: "Agents with limited sensing range moving towards formation while avoiding collisions" %}


This work is part of my Master's Thesis at the Royal Institute of Technology (KTH), Stockholm, Sweden (URL available soon). The scalable part of this work is inspired by the paper [Scalable Reinforcement Learning for Multi-Agent Networked Systems](https://arxiv.org/abs/1912.02906). The approach presented on the thesis exploits the structure of the designed reward to present $\Delta$-disk local approximation of the individual Q functions and policy gradients.

## Important Scripts

- [drone_env.py](https://github.com/AndreuMatoses/scalable-collision-avoidance-RL/blob/main/drone_env.py): Script containing the environment class and its methods. The main methods follow the structure of the OpenGym RL environments, such as `.step()` and `.reset()`.
- [train_problem.py](https://github.com/AndreuMatoses/scalable-collision-avoidance-RL/blob/main/train_problem.py): Script containing the training of the main problem.
- [SAC_agents.py](https://github.com/AndreuMatoses/scalable-collision-avoidance-RL/blob/main/SAC_agents.py): Script containing the agent classes and its policy classes
- [benchmark_agent.py](https://github.com/AndreuMatoses/scalable-collision-avoidance-RL/blob/main/benchmark_agent.py): Scripts to run trained agents and benchmark their performance

## Training of the scalable agents

The schema of the algorithm used is presented below. The scalable actor-critic agents are trained for each robotic agent. There are a total of *n* agents.

{% include "partials/figure.liquid", src: "training_schema.png", width: 600, alt: "Training schema" %}

## Structure of the training script

{% include "partials/figure.liquid", src: "training_script.png", width: 600, alt: "Training script structure" %}

## Relevant results

### Softmax discrete policy

The individual policy for each agent is of the shape:

{% include "partials/figure.liquid", src: "policy_softmax.png", width: 600, alt: "Discrete softmax policy" %}

Some examples of trajectories obtained after successful training are as follow

{% include "partials/figure.liquid", src: "trajectories_softmax.png", width: 600, alt: "Discrete softmax policy trajectories" %}

### Continuous normally distributed policy

The individual policy for each agent is of the shape:

{% include "partials/figure.liquid", src: "policy_normal.png", width: 600, alt: "Continuous normally distributed policy" %}

Some examples of trajectories obtained after successful training are as follow

{% include "partials/figure.liquid", src: "trajectories_normal.png", width: 600, alt: "Continuous normally distributed policy trajectories" %}

## Comparison of tested policies

The number of collisions displayed on the results are defined as an agent intersection with a neighbour’s collision radius in a given time step. Each agent counts collisions separately, thus two agents colliding is counted as two different collisions and a collisions that lasts for several times steps is is also counted as different collisions.

Percentage of simulations that achieve each number of collisions for each of the three tested policies, n = 5. The percentages for more than 14 collisions (under 1%) have been omitted.

{% include "partials/figure.liquid", src: "policy_comparison.png", width: 600, alt: "Comparison of tested policies" %}

Effect of the ∆-disk radius (definition 12 on the thesis) on the global reward and number of collisions, averaged over 2000 runs of the trained policies, for the discrete softmax NN policy

{% include "partials/figure.liquid", src: "delta_disk_effect.png", width: 600, alt: "Effect of the ∆-disk radius" %}

The results also show that the average reward starts to decrease after a certain value of $ \Delta_i $ , in this case around 1. The average number of collisions also increases sharply back to values where the agent has nearly no vision. This unexpected behaviours is the result of significant increase in the complexity of the maximization problem that the policy gradient is trying to solve. Taking into account an increasing number of neighbours and from further distances, increases the variance of the estimated approximated gradient and as a result, the policy used is not able to find improvements. Indeed, for the final case of $ \Delta_i \approx \hat{d}_{i} $ is not able to converge during training.
