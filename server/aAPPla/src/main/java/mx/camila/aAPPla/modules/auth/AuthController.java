package mx.camila.aAPPla.modules.auth;

import mx.camila.aAPPla.modules.user.UserDTO;
import mx.camila.aAPPla.modules.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin("*")
public class AuthController {
    @Autowired
    private AuthService authService;

    @Autowired
    private UserService usuarioService;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginDto dto){
       return authService.login(dto);
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody UserDTO usuario){
        return authService.register(usuario.toEntity());
    }

    @PutMapping("/updatePassword/{id}")
    public ResponseEntity<?> updatePassword(@PathVariable("id") Long id, @RequestBody LoginDto coso){
        return authService.updatePassword(id, coso);
    }

    @PutMapping("/updateProfile/{id}")
    public ResponseEntity<?> updateProfile(@PathVariable("id") Long id, @RequestBody UserDTO usuario){
        return usuarioService.update(usuario.toEntity(), id);
    }
}
