package foodiepass.server.controller;

import foodiepass.server.dto.request.ReconfigureRequest;
import foodiepass.server.dto.response.ReconfigureResponse;
import foodiepass.server.exception.dto.SuccessResponse;
import foodiepass.server.service.ReconfigurationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import static foodiepass.server.exception.enums.SuccessMessage.RECONFIGURE_SUCCESS;

@RestController
@RequiredArgsConstructor
public class ReconfigurationController {

    private final ReconfigurationService reconfigurationService;

    @PostMapping("/reconfigure")
    public ResponseEntity<SuccessResponse<List<ReconfigureResponse>>> reconfigure(
            @RequestBody final ReconfigureRequest request
    ) {
        final List<ReconfigureResponse> responses = reconfigurationService.reconfigure(request);
        return ResponseEntity.ok(SuccessResponse.of(RECONFIGURE_SUCCESS, responses));
    }
}
