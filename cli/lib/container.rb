require "docker"

def create_and_run_jenkins()
    base_jenkins_image = Docker::Image.create('fromImage' => 'jenkins/jenkins:lts')

    image_name = base_jenkins_image.info["RepoTags"][0]

    container = Docker::Container.create(   'Image' => image_name, 'HostConfig' => { "PortBindings": {"8080/tcp": [{ 'HostPort' => '8080'}]  }} )
    container.start
end
