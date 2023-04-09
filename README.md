So, Here's my task
1. produce the VPC and subnets with ip ports open and gateway only open for your IP only no other ip .

2. Attach that VPC to the machine do the ssh and host a website from that.

3. Create a a pipeline that once mchine is ready state install httpd and make it in running state. And wait for the approval and once gained host the web page on the machine.
  
SOLUTION:
1.) the VPC has been created and to open it for my gateway only, I had attatched VPC with a Nacl whose code is here
![Screenshot (62)](https://user-images.githubusercontent.com/101244905/230777297-346f657c-1050-4b9b-8ec2-681adce1286d.png)
 
 2.) A linux machiene is created within VPC and website is hosted in that
 ![Screenshot (63)](https://user-images.githubusercontent.com/101244905/230777405-dedf6d35-60cb-4500-afa3-46810a3b93b8.png)
   
      To host website-->
      ![Screenshot (57)](https://user-images.githubusercontent.com/101244905/230777434-031dcfe9-978e-4a2f-af63-a5013ba73458.png)
      ![Screenshot (60)](https://user-images.githubusercontent.com/101244905/230777462-898b85b0-6daa-4937-9ffc-6581fa68a44a.png)
      ![Screenshot (58)](https://user-images.githubusercontent.com/101244905/230777478-377f24be-ff76-400f-bc5d-0f661451e56b.png)
     
     And we can see our website running using Public IP of my instance
     ![Screenshot (61)](https://user-images.githubusercontent.com/101244905/230777512-8e73300b-3576-4bcc-9ce4-0f58740a6d8e.png)
  
  
  3.) Now the Pipeine is created, and to get approval, I had followed two approaches
    a)creating an planfile(which is in gitignore), and after approval of resources in planfile, it is applied
     
      ![Screenshot (64)](https://user-images.githubusercontent.com/101244905/230777866-ae395649-fbab-4b5e-a448-497fbc9d4595.png)

       terraform show -no-color -json planfile > plan.json(This command is used to show json format of plan file)
      
    b) Created a CICD pipeline, having first workflow till plan
      ![Screenshot (65)](https://user-images.githubusercontent.com/101244905/230778041-fd98758f-5f8a-4c02-86d2-f93191ebb788.png)
      
      And after the approval, we can run other workflow of apply
      ![Screenshot (66)](https://user-images.githubusercontent.com/101244905/230778264-17a9c99c-ea87-4189-b4f9-89c93d6d9db4.png)

      ![Screenshot (66)](https://user-images.githubusercontent.com/101244905/230778110-a23cda0e-bf39-40d2-bf53-6bb8ca8c31a6.png)
