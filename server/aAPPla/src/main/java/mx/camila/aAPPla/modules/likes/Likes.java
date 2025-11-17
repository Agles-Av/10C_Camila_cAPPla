package mx.camila.aAPPla.modules.likes;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import mx.camila.aAPPla.modules.publication.Publication;
import mx.camila.aAPPla.modules.user.User;

@Entity
@Table(name="likes")
public class Likes {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_publication")
    @JsonIgnoreProperties(value = {"publication","images","likes"})
    private Publication publication;


    @ManyToOne
    @JoinColumn(name = "id_user")
    @JsonIgnoreProperties(value = {"user","publicaciones","status","email"})
    private User user;

    public Likes(Long id, Publication publication, User user) {
        this.id = id;
        this.publication = publication;
        this.user = user;
    }

    public Likes(Publication publication, User user) {
        this.publication = publication;
        this.user = user;
    }

    public Likes() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Publication getPublication() {
        return publication;
    }

    public void setPublication(Publication publication) {
        this.publication = publication;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
