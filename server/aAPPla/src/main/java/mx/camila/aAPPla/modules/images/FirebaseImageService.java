package mx.camila.aAPPla.modules.images;
import com.google.cloud.storage.*;
import com.google.firebase.cloud.StorageClient;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;


@Service
public class FirebaseImageService {

    public String uploadImage(MultipartFile file) throws IOException {
        Bucket bucket = StorageClient.getInstance().bucket();

        String fileName = UUID.randomUUID().toString() + "-" + file.getOriginalFilename();

        Blob blob = bucket.create(
                fileName,
                file.getBytes(),
                file.getContentType()
        );

        blob.createAcl(Acl.of(Acl.User.ofAllUsers(), Acl.Role.READER));

        return String.format("https://storage.googleapis.com/%s/%s", bucket.getName(), fileName);
    }

}
