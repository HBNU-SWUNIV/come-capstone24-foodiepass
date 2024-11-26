package foodiepass.server.repository;

import foodiepass.server.entity.FoodInfoEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface FoodInfoRepository extends JpaRepository<FoodInfoEntity, Long> {

    Optional<FoodInfoEntity> findByName(String name);
}
