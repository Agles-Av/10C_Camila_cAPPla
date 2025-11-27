package mx.camila.aAPPla.modules.auth;

import mx.camila.aAPPla.modules.user.User;
import mx.camila.aAPPla.modules.user.UserDTO;
import mx.camila.aAPPla.modules.user.UserRepository;
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

    @PostMapping("/updatePassword")
    public ResponseEntity<?> updatePassword(@RequestParam String email, @RequestParam String newPass){
        return authService.updatePasswordWithCode(email, newPass);
    }

    @PostMapping("/send-code")
    public ResponseEntity<?> sendRecoveryCode(@RequestParam String email){
        return authService.sendRecoveryCode(email);
    }

    @PostMapping("/verify-code")
    public ResponseEntity<?> verifyRecoveryCode(@RequestParam String email, @RequestParam String code){
        return authService.validateRecoveryCode(email, code);
    }

    @PutMapping("/updateProfile/{id}")
    public ResponseEntity<?> updateProfile(@PathVariable("id") Long id, @RequestBody UserDTO usuario){
        return usuarioService.update(usuario.toEntity(), id);
    }

    @PostMapping("/update-fcm-token")
    public ResponseEntity<?> updateFcmToken(
            @RequestParam Long userId,
            @RequestParam String token
    ) {
        return usuarioService.updateFcmToken(userId, token);
    }

}
