package mx.camila.aAPPla.modules.images;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import mx.camila.aAPPla.modules.publication.Publication;
import mx.camila.aAPPla.modules.user.User;

@Entity
@Table(name = "images")
public class Images {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "url", nullable = false)
    private String url;


    @ManyToOne
    @JoinColumn(name = "id_publication")
    @JsonIgnoreProperties(value = {"publication","images","likes"})
    private Publication publication;

    public Images(Long id, String url, Publication publication) {
        this.id = id;
        this.url = url;
        this.publication = publication;
    }

    public Images(String url) {
        this.url = url;
    }

    public Images(String url, Publication publication) {
        this.url = url;
        this.publication = publication;
    }

    public Images() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Publication getPublication() {
        return publication;
    }

    public void setPublication(Publication publication) {
        this.publication = publication;
    }
}
