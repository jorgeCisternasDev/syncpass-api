package cl.duoc.syncpass.config;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Rutas del panel web que no son archivos ni endpoints de la API.
 * Se devuelve el index de React para que el router del navegador resuelva la vista.
 */
@Controller
public class SpaForwardController {

    @GetMapping({"/", "/login", "/usuarios", "/proyectos", "/eventos"})
    public String index() {
        return "forward:/index.html";
    }
}
