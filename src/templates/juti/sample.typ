#import "@nafkhanzam/common:0.0.1": t-juti

#let authors = (
  (
    name: [First A. Author],
    short: [First A. Author],
    institution-ref: 0,
    email: [first.author\@email.com],
    contribution: [Writing -- review & editing, Writing -- original draft, Validation, Software, Methodology, Conceptualization],
  ),
  (
    name: [Second B. Author],
    short: [Second B. Author],
    institution-ref: 0,
    email: [second.author\@email.com],
    contribution: [Writing -- original draft, Formal analysis, Data curation, Conceptualization],
  ),
  (
    name: [Third C. Author],
    short: [Third C. Author],
    institution-ref: 1,
    email: [third.author\@email.com],
    contribution: [Writing -- original draft, Software, Investigation],
  ),
)

#show: t-juti.template.with(
  title: [
    Evaluating Object Collection in Emergency Simulations Using Virtual and Augmented Reality
  ],
  authors: authors,
  corresponding-ref: 0,
  institutions: (
    (
      name: [Department and institution name of authors],
      address: [Address of institution],
    ),
    (
      name: [Department and institution name of authors],
      address: [Address of institution],
    ),
  ),
  abstract: [
    Virtual Reality (VR) and Augmented Reality (AR) are two technologies that have received significant attention in recent years. While both hold immense potential, they offer distinct ways for users to interact with digital content and their physical surroundings. This research aims to evaluate the interaction between users and a collection of objects in both VR and AR settings. To achieve this, a user study was conducted with 24 participant using Meta Quest 3 headset to run simulation in both environments. The study focused on tasks related to object collection and emergency management while utilizing combination of objective and subjective metrics to evaluate user interactions in both VR and AR environments. Despite the relatively close scores for both result, research shows that participants prefer AR for emergency simulations over VR. Even considering participants' first-time use of the applications, AR remains more popular, supported by lower symptom rates reported in the sickness than VR. Additionally, participants tended to focus more on collecting small objects, though VR users often forgot these items, while medium-sized objects were more frequently overlooked in AR. Although VR users experienced more human errors related to collisions with real objects, the overall impact on immersion during simulations was not significant enough to favor one technology over the other. Based on this result, it can be said that while VR is better for showing immersion, it is generally better for a first-time user to engage in AR first since it will give less incidence of virtual sickness.
  ],
  keywords: (
    [Augmented Reality],
    [Virtual Reality],
    [Virtual Objects],
    [User Interaction],
    [Immersion],
    [Symptom Rates],
  ),
  bib: bibliography("references.bib", full: true),
)

= Introduction

The increase in virtual reality (VR) and augmented reality (AR) technology has resulted in a major turnaround in many fields. One such example is its use in disaster management simulation. VR or AR provides a safer and more controlled environment for the community to practice evacuation procedures and decision-making skills compared to a real live simulation. By immersing participants in realistic scenarios, VR and AR enhance engagement and retention of critical information and allow for the repetition of training exercises without the logistical challenges and risks associated with live drills.

While VR and AR offer immersive experiences, they differ in their fundamental approaches. VR creates a truly immersive experience that can transport users into virtual environments and make them feel as if they are physically there. On the other hand, AR layers digital content on top of the real world, enhancing it with digital details that complement the environment. Additionally, VR requires a compatible device such as a headset, while AR can be used via mobile devices, displays, and cameras, making it more accessible.

With this difference in mind, the way users interact with objects in these environments is also fundamentally different. In AR, users interact with virtual objects superimposed onto a real-world environment. This means that users can view and interact with digital content while still paying attention to the physical environment around them. On the other hand, VR creates a fully immersive digital environment that replaces the real world. Users wear a VR headset that blocks out the physical world and presents them with a visual and audio simulation experience. This means that users can interact with digital objects more naturally and intuitively because the user is entirely in the virtual environment. The differences in user interaction between AR and VR have essential implications for the design and development of applications in each technology. AR apps must be designed to work seamlessly with real-world environments, while VR apps must create truly immersive experiences that feel natural and intuitive to the user.

Many research studies have explored the interaction between the user and AR, VR, or even both. Such research shows many results suggesting either the usage of VR and AR in many fields or investigating user behavior in VR or AR. One study investigated user interactions and error rates within AR and VR environments using a simulated dataset to analyze how these interactions impact system performance and overall user experience @chirumamilla2020cheating. By analyzing the dataset, mainly containing about four actions in the environment, which are "Select," "Drag," "Resize," and "Rotate", this research gives insight into how to optimize the user experience and the system itself based on the result of the prediction of error from the certain actions. While the research before explored the dataset of user interaction using the action itself, another research explored how the users engage and communicate within hybrid virtual environments that combine AR and VR, which focuses on identifying the factors that facilitate interactions and conversations among multiple users when experiencing cultural heritage objects @hietanen2021security. Another study explored the differences between VR and AR in terms of interactivity, sense of presence, sensory experience of brand apps, attitudes, and behavioral intent @mendoncca2024evaluating. The experiment was conducted natively in a shopping environment at IKEA. Another study examined the effects of an agent providing navigation aids in a virtual environment @inep2022relatorio. They designed a virtual agent to help users explore the virtual world of a museum and provide instructions from objects that users can interact with. In addition, the study examined how social interaction can affect visitors from VR users of underwater seascape exploration @bubble2016pyimagesearch. The experiment was carried out by asking visitors to use VR to explore two scenes created about flora, fauna, and the underwater environment around the user in the virtual world. Another study applied AR and VR to preserve an element of ancient culture @abbas2009automatic digitally. The application was made on a smartphone, and it interacted with several objects. AR and VR systems were also applied to explore historical cityscape tours @yuhana2022automatic. The scenery was displayed panoramic using unmanned airborne vehicle (UAV) photography. A study developed a VR and AR-based display system for arts and crafts museums to create an immersive and interactive experience for museum visitors, allowing visitors to explore the exhibits more engaging and informatively @chirumamilla2020cheating.

Even so, this research investigating user behavior was mainly related to the user and the virtual interface surrounding the user or the virtual objects in VR or real objects in AR. A virtual object is defined as any item that exists within a digital environment and typically lacks specific shapes or textures. Generally, one can refer to any object within a virtual environment as a virtual object. This research focused on the interaction between the user and the virtual object inside a VR and AR simulation. The virtual object defined in this research was the object the user required to “Collect" and “Use." To describe it more, this research divided the object into three groups based on their size, which are “Small," “Medium," and “Large." To make it more engaging for the user, the simulation environment used in this research for each VR and AR is a virtual replica based on a concept of Digital Twin of an informatics laboratory/computer lab for the VR and the use of Passthrough in Meta Quest 3 for AR.

= Literature Review

#lorem(100)
Table example can be seen on @tab-example.
Image example can be seen on @img-example.
The Schrodinger's famous equation can be seen on @eq-example.
$ i ħ (∂ψ) / (∂t) = - (ħ^2) / (2m) ∇^2ψ + V ψ $ <eq-example>

#figure(
  table(
    columns: 4,
    table.hline(),
    table.header([*No*], [*Year*], [*Climate Change Event*], [*Impact*]),
    table.hline(),
    [1], align(left)[1988], align(left)[Establishment of the IPCC], align(left)[Increased global awareness and scientific assessments],
    [2], align(left)[1997], align(left)[Kyoto Protocol Adopted], align(left)[Legally binding emission reduction targets for developed countries],
    [3], align(left)[2015], align(left)[Paris Agreement Signed], align(left)[Global commitment to limit warming below 2°C],
    [4], align(left)[2021], align(left)[COP26 Held in Glasgow], align(left)[Strengthened climate targets and financial commitments],
    [5], align(left)[2009], align(left)[Copenhagen Accord], align(left)[Pledged climate finance of \$100 billion per year],
    [6], align(left)[2007], align(left)[IPCC Fourth Assessment Report], align(left)[Highlighted human influence on climate change],
    [7], align(left)[2018], align(left)[IPCC Special Report on 1.5°C], align(left)[Urgent need for emission reductions to avoid severe impacts],
    table.hline(),
  ),
  caption: [Table example.],
) <tab-example>

#figure(
  image("img.jpg", width: 40%),
  caption: [Image example.],
) <img-example>

#lorem(100)

#lorem(100)

#lorem(100)

#set heading(numbering: none)

= CRediT authorship contribution statement

#authors.map(author => [*#author.short:* #author.contribution.]).join([ ])

= Declaration of competing interest

The authors declare that they have no known competing financial interests or personal relationships that could have appeared to influence the work reported in this paper.

= Acknowledgement

This research was funded by ...

= Data availability

Please choose the appropriate data availability statement that applies to this study. If none apply, provide a custom statement.
- The data used to support the findings of this study are available from the corresponding author upon request.
- All relevant data are within the manuscript and its supporting information files.
- The dataset was openly provided [link provided].
- Data sharing is not applicable to this article as no datasets were generated or analyzed during the current study.
- Data sharing is not applicable as the data are secondary data drawn from already published literature.
- Data sharing not applicable to this article as no datasets were generated or analyzed during the current study. The datasets generated during and/or analyzed during the current study are available from the corresponding author on reasonable request.
