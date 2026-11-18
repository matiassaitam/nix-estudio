let
  project = {
    name = "aula";
    port = 8080;
  };
  hosts = [ "localhost" "127.0.0.1" ];
  makeUrl = host: "http://${host}:${toString project.port}";
in
{
  name = project.name;
  port = project.port;
  enabled = true;
  inherit hosts;
  url = makeUrl "localhost";
}
