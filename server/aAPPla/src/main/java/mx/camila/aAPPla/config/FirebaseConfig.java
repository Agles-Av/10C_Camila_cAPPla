package mx.camila.aAPPla.config;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.List;

@Configuration
public class FirebaseConfig {

    @Bean
    public FirebaseApp firebaseApp() throws IOException {
        // 1. Buscamos la variable en el sistema (La que pondremos en Railway)
        String base64Credentials = System.getenv("FIREBASE_CREDENTIALS");

        if (base64Credentials == null || base64Credentials.isEmpty()) {
            // Esto es por si quieres seguir corriendo en local sin configurar la variable,
            // aunque te recomiendo configurar la variable de entorno en tu IDE también.
            throw new RuntimeException("ERROR CRÍTICO: No se encontró la variable FIREBASE_CREDENTIALS");
        }

        // 2. Decodificamos el Base64 a bytes reales
        byte[] decodedBytes = Base64.getDecoder().decode(base64Credentials);

        // 3. Creamos un flujo de datos en memoria (simulando que es un archivo)
        ByteArrayInputStream serviceAccountStream = new ByteArrayInputStream(decodedBytes);

        FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccountStream))
                .build();

        // Evita errores si Spring recarga el contexto
        List<FirebaseApp> apps = FirebaseApp.getApps();
        if (apps != null && !apps.isEmpty()) {
            for (FirebaseApp app : apps) {
                if (app.getName().equals(FirebaseApp.DEFAULT_APP_NAME)) {
                    return app;
                }
            }
        }

        return FirebaseApp.initializeApp(options);
    }
}
