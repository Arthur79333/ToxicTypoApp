# toxictypoapp

**Work plan:**

    Download the ToxicTypoApp to your local machine.  
    Open a new repository in your GitLab, and upload it there.  
    Dockerize the application (multi-stage):  
    a. Use a Maven container for the build (`mvn verify` will create the artifact in the `target` folder).  
    b. Use an eclipse-temurin base container image for runtime (application listens on port 8080).  
    Run the E2E tests using a Python 2.7 container and the script from `src/test/e2e_tests.py`.  
    Create a Jenkins pipeline:      
    - `main` branch does: Build, test, deploy to AWS.    
