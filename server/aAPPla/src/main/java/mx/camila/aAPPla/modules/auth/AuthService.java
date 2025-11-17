package mx.camila.aAPPla.modules.auth;

import mx.camila.aAPPla.config.CustomResponse;
import mx.camila.aAPPla.modules.user.User;
import mx.camila.aAPPla.modules.user.UserRepository;
import mx.camila.aAPPla.security.token.JwtProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class AuthService {
    @Autowired
    private UserRepository useRepository;

    @Autowired
    private CustomResponse customResponse;


    private final AuthenticationManager manager;
    private final JwtProvider provider;
    private final PasswordEncoder encoder;

    public AuthService(AuthenticationManager manager, JwtProvider provider, PasswordEncoder encoder) {
        this.manager = manager;
        this.provider = provider;
        this.encoder = encoder;
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseEntity<?> login(LoginDto dto) {
        System.out.println("DTO contraseña llega como: " + dto.getContrasena());

        System.out.println("banana1");
        System.out.println(dto);

        try {
            User foundUser = useRepository.findByEmail(dto.getEmail());
            if (foundUser == null)
                return customResponse.get400Response(404);

            // Validar si está activo
            if (!foundUser.getStatus())
                return customResponse.getBadRequest("Usuario inactivo");
            Authentication auth = manager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            dto.getEmail(),
                            dto.getContrasena()
                    )
            );

            // Guardar autenticación
            SecurityContextHolder.getContext().setAuthentication(auth);

            // Generar el token
            String token = provider.generateToken(auth);


            // Crear DTO firmado
            SignedDto signedDto = new SignedDto(token, "Bearer", foundUser);

            return customResponse.getLoginJSONResponse(signedDto);

        } catch (Exception e) {
            e.printStackTrace();
            return customResponse.get400Response(400);
        }
    }


    @Transactional(rollbackFor = Exception.class)
    public ResponseEntity<?> register(User user){
        if (useRepository.findByEmail(user.getEmail()) != null)
            return customResponse.getBadRequest("Correo ya registrado");
        user.setContrasena(encoder.encode(user.getContrasena()));
        user.setStatus(true);
        return customResponse.getJSONResponse(useRepository.save(user));
    }

    @Transactional(rollbackFor = Exception.class)
    public ResponseEntity<?> updatePassword(Long id, LoginDto coso){
        Optional<User> foundUser = useRepository.findById(id);
        if (!foundUser.isPresent())
            return customResponse.get400Response(404);
        User user = foundUser.get();
        user.setContrasena(encoder.encode(coso.getContrasena()));
        return customResponse.getJSONResponse(useRepository.saveAndFlush(user));
    }


    @Transactional(rollbackFor = Exception.class)
    public ResponseEntity<?> save(User user){
        if (useRepository.findByEmail(user.getEmail()) != null)
            return customResponse.getBadRequest("Correo ya registrado");
        user.setContrasena(encoder.encode(user.getEmail()));
        user.setStatus(true);
        return customResponse.getJSONResponse(useRepository.save(user));
    }
}
