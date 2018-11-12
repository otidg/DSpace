/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.rest.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * Conflict request (e.g. missed mandatory field) specified with a 409 (Conflict)
 * The request could not be completed due to a conflict with the current state of the target resource.
 * This code is used in situations where the user might be able to resolve the conflict and resubmit the request.
 *
 * @author Giuseppe Digilio (giuseppe.digilio at 4science.it)
 */
@ResponseStatus(value = HttpStatus.CONFLICT, reason = "Conflict")
public class ConflictException extends RuntimeException {

    public ConflictException() {
        super("Conflict during request process");
    }

    public ConflictException(String message) {
        super(message);
    }
}