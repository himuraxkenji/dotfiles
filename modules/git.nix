_:

{
  programs = {
    git = {
      enable = true;
      settings.user = {
        name = "himuraxkenji";
        email = "aaron.ariperto@gmail.com";
      };

      includes = [
        {
          # Ejemplo — reemplazar por la ruta y datos reales de la segunda cuenta
          condition = "gitdir:~/work/";
          contents.user = {
            name = "himura-work";
            email = "himura@work-example.com";
          };
        }
      ];
    };

    gh.enable = true;
    lazygit.enable = true;
  };
}
