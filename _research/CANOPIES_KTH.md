---
title: "Linear Temporal Logic (LTL) Planner for Agricultural Robotics"
venue: "IEEE International Conference on Automation Science and Engineering (CASE) 2024"
authors:
    - name: "Shankar Deka"
      superscript: "1"
    - name: "Sujet Phodapol"
      superscript: "2"
    - name: "Andreu Matoses Gimenez"
      superscript: "3"
    - name: "Victor Nan Fernandez-Ayala"
      superscript: "2"
    - name: "Rufus Cheuk Yin Wong"
      superscript: "2"
    - name: "Pian Yu"
      superscript: "4"
    - name: "Xiao Tan"
      superscript: "5"
    - name: "Dimos V. Dimarogonas"
      superscript: "2"
affiliations:
    - name: "Aalto University"
      url: "https://www.aalto.fi/en"
      superscript: "1"
    - name: "KTH Royal Institute of Technology"
      url: "https://www.kth.se/en"
      superscript: "2"
    - name: "Delft University of Technology"
      url: "https://www.tudelft.nl/en"
      superscript: "3"
    - name: "University of Oxford"
      url: "https://www.ox.ac.uk/"
      superscript: "4"
    - name: "California Institute of Technology"
      url: "https://www.caltech.edu/"
      superscript: "5"
date: 2023-09-01
# This is the short project description, displayed in the project's card"
description: "Implemented a ROS based linear temporal logic (LTL) planner for the CANOPIES ERC: Collaborative Paradigm for Human Workers and Multi-Robot Teams in Precision Agriculture Systems."
cover_image: /assets/images/papers/canopies/canopies_rome_test_43_short_good.gif # Image displayed in the project's card, make it aspect ratio 1x1 (square) for best results, and keep it a reasonable size (like 1-2MB). Can also be a gif
links: # If you have other website for the project, github repos, datasets, etc. put it here. You can also add an icon from https://icons.getbootstrap.com/
    - name: Paper
      icon: bi-file-earmark-pdf
      url: "https://ieeexplore.ieee.org/abstract/document/10711319"
    - name: ERC website
      url: "https://www.canopies-project.eu/"
    - name: Code
      icon: bi-github
      url: "https://github.com/KTH-DHSG/ltl_automaton_core"

gallery_experiments:
  - "/assets/images/papers/canopies/canopies_rome_test_43_short_good.gif"
  - "/assets/images/papers/canopies/canopies_rome_test_unload.gif"
---

{% include gallery.html images=page.gallery_experiments n_columns=2 caption="Robots in the vineyard in Rome" %}

Work published in 2024 IEEE 20th International Conference on Automation Science and Engineering (CASE) as *Enhancing Precision Agriculture through Human-In-The-Loop Planning and Control*, see [publications]({{ site.baseurl }}/publications).

## Abstract
In this paper, we introduce a ROS based framework designed for the planning and control of robotic systems within the context of precision agriculture, with an emphasis on human-in-the-loop capabilities. Utilizing Linear Temporal Logic to articulate complex task specifications, our algorithm creates high-level robotic plans that are not only correct by design but also adaptable in real time by human operators. This dual-focus approach ensures that while humans have the flexibility to modify the high-level plan on-the-fly or even take over low-level control of the robots, the system inherently safeguards against any human actions that could potentially breach the predefined task specifications. We demonstrate our algorithm within the dynamic and challenging environment of a real vineyard, where the collaboration between human workers and robots is critical for tasks such as harvesting and pruning, and show the practical applicability and robustness of our software. This work marks a pioneering application of formal methods to complex, real-world agricultural environments.
