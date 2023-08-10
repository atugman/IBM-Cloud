I recently cleared the HashiCorp Certified: Terraform Associate (003) exam. Here are a few takeaways from my experience with the exam, my experience with Terraform as a whole, and (optionally) a couple of lab exercises.

**Key Resources**

- Udemy Prep Course - HashiCorp Certified: Terraform Associate 2023: https://ibm-learning.udemy.com/course/terraform-beginner-to-advanced
  - Note that you can skip the section on provisioners, which was removed from the 003 exam.
 
- Practice test via O'Reilly / Pearson: https://learning.oreilly.com/certifications/9780138190408/
  - Use the documentation provided in the feedback of each question!

For any IBMers reading this, we have access to each of these.

- Practice locally
  - This will be particularly helpful to anyone newer to Terraform. More on this below.

**General Thoughts**

All in all, I had a good experience taking the exam. As with most technical certifications, I don't feel that it covers *everything* that one needs to know to be a perfectly fluent SRE or developer who writes beautiful, bullet-proof, production-grade code. But, I do think it aligns well overall with 'the real world' so to speak, and should serve as a solid foundation for anyone newer to IaC, or experienced individuals looking to validate their knowledge of Terraform.

If you do have experience with Terraform, your required prep time should be reduced significantly. I found many questions throughout the exam intuitive - particularly ones that I presume fell into the [navigating the terraform workflow section](https://developer.hashicorp.com/terraform/tutorials/certification-003/associate-study-003#navigate-the-core-workflow), (and likely a few the other basic sections). These types of questions should be easy to reason through for experienced Terraformers and align to general Terraform tasks performed on a daily basis.

I relied primarily on previous experience and reviewing some nuances of HashiCorp Language to help with some of the more tedious concepts. For example, questions that require reading through code blocks like [this](https://developer.hashicorp.com/terraform/tutorials/certification-003/associate-questions#examples) (I found several questions that required reading code blocks to be a bit more complex than this). For the most part though, if you've written enough HCL, even these should be straightforward (or you should at least be able to 'eyeball' the correct answer via the syntax), but it doesn't hurt to review, as some of the answer choices will look pretty similar.

The biggest recommendation I would share, particularly to newer Terraformers and coders, pertains to both preparing for the exam, and generally improving your coding skills. **Practice, practice, practice.** *Most* of your code, whether it's HashiCorp Language or not, is not going to work *perfectly* (or sometimes even at all) the first time that you write it. This is no surprise to experienced developers, engineers, etc. But understanding error messages, or why your code didn't result in the exact outcome that you anticipated will go a long way both in terms understanding key Terraform concepts that will help you reason through the exam, and in terms of becoming a better coder.

**Value of Terraform**

My last comment will speak to the value of Terraform. I think this concept *could* get lost in the shuffle of preparing for the exam, but let me speak to one of my favorite aspects of Terraform through a real-world example.

You've all probably heard the buzzwords around IaC. Strict configurations (same deployment each time). Faster deployments. Faster time to market. Efficiency. Reduced manual tasks. and so on. What does it all *really* mean and where is the real value to a developer?

Strictly (buzz word intended) in terms of provisioning tools (not branching out into the realm of configuration management tools like Ansible), Terraform, in my opinion, has become the gold standard across enterprises, and rightfully so. I've seen ambitious SREs who handle a lot of provisioning through Python and other custom-written applications, and they did so exceedingly well. Their programs met all of the needs of their given enterprises, but don't have as much reuse value as something like Terraform. One of the hardest tasks in software engineering is to pick up someone else's code and start using it, much less maintaining and patching it as if it were your own. HashiCorp language is not a complete exception to this phenomenon, but it will significantly reduce the time to transfer ownership of a codebase (say a developer leaves a company) from one developer or team to another because of this "standardization." A large part of this "standardization" stems from the support of Terraform providers, who are affording deployers of their software a standard ways of interacting with their API by proxy of Terraform via HCL.

Perhaps the aforementioned ambitious SRE finds HCL a bit restrictive, or overly prescriptive in terms of functionality. Maybe they aren't used to writing HCL, or otherwise prefers Python because it aligns to their current skill set. I empathize with this individual because they are likely automating many of their other daily tasks (or tasks across their enterprise) in Python or other similar programming languages. Why not provision infrastructure using the same skills? Well, we've talked about the transfer of ownership of a codebase, but that's probably not the biggest thing on *this* developer's mind. However, I would urge this individual to consider everything that Terraform would take off of *their* plate as well.

The effort to learn HCL will pay big dividends faster than you think. It's easy enough to pick a language out of a hat, and find an SDK that enables you to quickly start writing code to create, destroy and update your cloud infrastructure. But, you could be missing out on state management capabilities (which are foundational to Terraform), as well as the built-in capabilities that Terraform uses to manage dependencies between cloud resources. And plenty of other valuable features that would take a much larger programming (not to mention software testing) effort to implement in another language besides HCL.

What if I used Python to create 6 VPCs that each contain between 18-22 VMs that are part of one of 5 different scaling groups and were each created from one of 8 different instance templates? Then, a new requirement arises where some of my infrastructure configurations need to be updated. Think of all of the resources that depend on each other in this type of architecture.