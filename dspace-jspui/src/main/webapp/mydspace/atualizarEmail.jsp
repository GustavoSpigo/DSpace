<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.UUID, org.dspace.core.*, org.dspace.eperson.*, org.dspace.eperson.service.*, org.dspace.eperson.factory.*, org.dspace.authorize.*" %>
<%! 
private static final org.apache.log4j.Logger logger = 
    org.apache.log4j.Logger.getLogger("mydspace.emails.atualizarEmail");
%>
<%
    request.setCharacterEncoding("UTF-8");
    
    String novoEmail = request.getParameter("novoEmail");
    String erro = null;
    
    if (novoEmail == null || novoEmail.trim().isEmpty()) {
        erro = "Por favor, informe um e-mail.";
    } else {
        novoEmail = novoEmail.trim().toLowerCase();
        
        if (!novoEmail.matches("^[a-zA-Z0-9._%+-]+@cps\\.sp\\.gov\\.br$")) {
            erro = "O e-mail deve ser do domínio @cps.sp.gov.br.";
        }
    }
    
    if (erro == null) {
        UUID currentUserId = null;
        Object userIdObj = session.getAttribute("dspace.current.user.id");
        if (userIdObj instanceof UUID) {
            currentUserId = (UUID) userIdObj;
        } else if (userIdObj != null) {
            try {
                currentUserId = UUID.fromString(userIdObj.toString());
            } catch (Exception e) {
                logger.debug("Invalid user ID format: " + userIdObj);
            }
        }
        
        if (currentUserId == null) {
            erro = "Sessão expirada. Faça login novamente.";
        } else {
            Context dspaceContext = null;
            try {
                dspaceContext = new Context();
                
                // Disable authorization for this operation (user is updating own email)
                dspaceContext.turnOffAuthorisationSystem();
                
                try {
                    // Use DSpace EPerson service API (native, not JDBC)
                    EPersonService ePersonService = EPersonServiceFactory.getInstance().getEPersonService();
                    
                    // Check if email already exists for another user
                    EPerson existingUser = ePersonService.findByEmail(dspaceContext, novoEmail);
                    if (existingUser != null && !existingUser.getID().equals(currentUserId)) {
                        erro = "Este e-mail já está em uso por outro usuário.";
                        logger.warn("Email already in use: " + novoEmail);
                    } else {
                        // Get current user and update email
                        EPerson user = ePersonService.find(dspaceContext, currentUserId);
                        if (user == null) {
                            erro = "Usuário não encontrado. Contate o administrador.";
                            logger.warn("User not found: " + currentUserId);
                        } else {
                            // Update email
                            user.setEmail(novoEmail);
                            ePersonService.update(dspaceContext, user);
                            dspaceContext.complete();
                            
                            logger.info("Email updated successfully for user: " + currentUserId + " to " + novoEmail);
                            session.setAttribute("emailMigracaoSucesso", "E-mail atualizado com sucesso!");
                            response.sendRedirect(request.getContextPath() + "/mydspace?sucesso=1");
                            return;
                        }
                    }
                } catch (SQLException sqlError) {
                    logger.error("Database error updating email: " + sqlError.getMessage(), sqlError);
                    erro = "Erro ao atualizar e-mail. Contate o administrador.";
                } catch (Exception serviceError) {
                    logger.error("Service error updating email: " + serviceError.getMessage(), serviceError);
                    erro = "Erro ao atualizar e-mail. Contate o administrador.";
                }
                
            } catch (Exception e) {
                logger.error("Error updating email for user " + currentUserId + ": " + e.getMessage(), e);
                erro = "Erro ao atualizar e-mail. Contate o administrador.";
            } finally {
                if (dspaceContext != null && dspaceContext.isValid()) {
                    try {
                        dspaceContext.abort();
                    } catch (Exception cleanupError) {
                        logger.debug("Error aborting DSpace context: " + cleanupError.getMessage());
                    }
                }
            }
        }
    }
    
    if (erro != null) {
        session.setAttribute("emailMigracaoErro", erro);
    }
    response.sendRedirect(request.getContextPath() + "/mydspace");
%>
