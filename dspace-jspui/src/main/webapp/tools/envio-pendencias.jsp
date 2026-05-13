<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.sql.*, org.dspace.core.*, org.dspace.storage.rdbms.*, org.dspace.core.Email, org.dspace.core.I18nUtil" %>
<%
    // --- Script colocado no DSpace 6 ---
    // --- SEGURANÇA ---
    String tokenSeguranca = "ALTERE_ISTO_PARA_ALGO_COMPLEXO";

    String chaveRecebida = request.getParameter("key");
    String motivoBloqueio = null;
    if (chaveRecebida == null || chaveRecebida.trim().isEmpty()) {
        motivoBloqueio = "Parametro key nao foi informado na URL.";
    } else if (!tokenSeguranca.equals(chaveRecebida)) {
        motivoBloqueio = "Parametro key informado e invalido.";
    }

    if (motivoBloqueio != null) {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        out.println("<div style='max-width:900px;margin:20px auto;padding:20px;border:1px solid #f3c5c5;background:#fff7f7;font-family:Segoe UI,Tahoma,Arial,sans-serif;color:#3f1d1d;line-height:1.45;'>");
        out.println("<h2 style='margin:0 0 12px 0;color:#9f1239;'>HTTP Status 403 - Forbidden</h2>");
        out.println("<p style='margin:0 0 10px 0;'><b>Motivo:</b> " + motivoBloqueio + "</p>");
        out.println("<p style='margin:0 0 10px 0;'><b>Como resolver:</b></p>");
        out.println("<ol style='margin:0 0 0 18px;padding:0;'>");
        out.println("<li>Defina um valor real para a variavel <b>tokenSeguranca</b> no JSP.</li>");
        out.println("<li>Acesse a pagina com <b>?key=SEU_TOKEN</b> na URL.</li>");
        out.println("</ol>");
        out.println("</div>");
        return;
    }

    String parametroTeste = request.getParameter("teste");
    int limiteTeste = 0;
    if (parametroTeste != null) {
        try {
            int valorTeste = Integer.parseInt(parametroTeste.trim());
            if (valorTeste > 0) {
                limiteTeste = valorTeste;
            }
        } catch (Exception ignore) {
            // Valor invalido de teste: segue como envio oficial.
        }
    }
    boolean modoTeste = limiteTeste > 0;
    String emailTeste = "gustavo@spigo.net";

    Context context = new Context();
    StringBuilder etapasHtml = new StringBuilder();
    StringBuilder itensHtml = new StringBuilder();
    StringBuilder enviosHtml = new StringBuilder();

    adicionarItemRelatorio(etapasHtml, "Processamento iniciado");
    adicionarItemRelatorio(etapasHtml, "Token de seguranca validado");
    adicionarItemRelatorio(etapasHtml, "Modo teste: " + (modoTeste ? "ATIVO" : "DESATIVADO"));
    if (modoTeste) {
        adicionarItemRelatorio(etapasHtml, "Limite do modo teste: " + limiteTeste + " item(ns)");
        adicionarItemRelatorio(etapasHtml, "Modo teste ativo: destinatario forçado para " + emailTeste);
    }
    
    try {
        // Sua Query SQL Otimizada
        String sql =
            "SELECT ri.request_date, " +
            "       ri.request_email AS solicitante_email, " +
            "       'https://ric.cps.sp.gov.br/handle/' || handle.handle AS link_visualizar_item, " +
            "       'https://ric.cps.sp.gov.br/request-item?step=2&token=' || ri.token AS link_decisao_direta, " +
            "       CASE " +
            "           WHEN UPPER(cc_m.text_value) LIKE '%FATEC%' THEN CONCAT('f', LEFT(cc_m.text_value, 3), 'bibli@cps.sp.gov.br') " +
            "           WHEN UPPER(cc_m.text_value) LIKE '%ETEC%' THEN CONCAT('e', LEFT(cc_m.text_value, 3), 'bibli@cps.sp.gov.br') " +
            "           WHEN cc_m.text_value = '001 - Graduação Tecnológica à Distância (EAD)' THEN 'nucleobibli@cps.sp.gov.br' " +
            "           WHEN cc_m.text_value = '001 - Grupo de Estudo de Educação a Distância (GEEaD)' THEN 'f002bibliead@cps.sp.gov.br' " +
            "           ELSE 'ric@cps.sp.gov.br' " +
            "       END AS email_decisao_direta " +
            "FROM requestitem ri " +
            "JOIN collection2item ci " +
            "  ON ci.item_id = ri.item_id " +
            "JOIN metadatavalue c_m " +
            "  ON c_m.dspace_object_id = ci.collection_id " +
            " AND c_m.metadata_field_id = 70 " +
            "JOIN community2collection cc " +
            "  ON cc.collection_id = ci.collection_id " +
            "JOIN metadatavalue cc_m " +
            "  ON cc_m.dspace_object_id = cc.community_id " +
            " AND cc_m.metadata_field_id = 70 " +
            "JOIN handle " +
            "  ON ri.item_id = handle.resource_id " +
            " AND handle.resource_type_id = 2 " +
            "WHERE ri.accept_request IS NULL " +
            "  AND NOT (request_email LIKE '%testing@example.com%') " +
            "  AND NOT (request_email LIKE '%--%') " +
            "  AND (request_email LIKE '%@%') " +
            "  AND NOT (request_email LIKE '%@@%') " +
            "ORDER BY email_decisao_direta, ri.request_date DESC";

        if (modoTeste) {
            sql += " LIMIT " + limiteTeste;
        }

        adicionarItemRelatorio(etapasHtml, "Consulta preparada com sucesso");

        String currentDestinatario = "";
        StringBuilder listaItensHtml = new StringBuilder();
        StringBuilder listaItensTexto = new StringBuilder();
        int itensNoLote = 0;
        int countEmailsEnviados = 0;
        int countRegistros = 0;

        List linhas = executarConsultaPendencias(context, sql, etapasHtml);
        for (int i = 0; i < linhas.size(); i++) {
                Map linha = (Map) linhas.get(i);
                countRegistros++;
                String emailDestino = modoTeste ? emailTeste : valorComoTexto(linha.get("email_decisao_direta"));
                itensHtml.append("<li><b>Registro ")
                         .append(countRegistros)
                         .append("</b>: solicitante ")
                         .append(escaparHtml(valorComoTexto(linha.get("solicitante_email"))))
                         .append(" | destinatario ")
                         .append(escaparHtml(emailDestino))
                         .append(" | data ")
                         .append(valorComoTexto(linha.get("request_date")))
                         .append("</li>");

                // Quando mudar o destinatário na lista ordenada, envia o anterior
                if (!currentDestinatario.equals("") && !currentDestinatario.equals(emailDestino)) {
                    adicionarItemRelatorio(etapasHtml, "Mudanca de destinatario detectada");
                    enviarLote(context, currentDestinatario, listaItensHtml.toString(), listaItensTexto.toString(), itensNoLote);
                    countEmailsEnviados++;
                    enviosHtml.append("<li>Lote enviado para <b>")
                             .append(escaparHtml(currentDestinatario))
                             .append("</b></li>");
                    listaItensHtml = new StringBuilder();
                    listaItensTexto = new StringBuilder();
                    itensNoLote = 0;
                }

                currentDestinatario = emailDestino;

                // Monta um bloco HTML para cada item do e-mail
                listaItensHtml.append("<li style='margin-bottom:12px;padding:12px;border:1px solid #e2e8f0;background:#ffffff;'>");
                listaItensHtml.append("<div><b>Data:</b> ").append(escaparHtml(valorComoTexto(linha.get("request_date")))).append("</div>");
                listaItensHtml.append("<div><b>Solicitante:</b> ").append(escaparHtml(valorComoTexto(linha.get("solicitante_email")))).append("</div>");
                listaItensHtml.append("<div><b>Link de decisao:</b> ");
                listaItensHtml.append("<a href='").append(escaparHtml(valorComoTexto(linha.get("link_decisao_direta")))).append("'>");
                listaItensHtml.append("Acessar solicitacao");
                listaItensHtml.append("</a></div>");
                listaItensHtml.append("</li>");

                // Monta a versão texto do mesmo item para fallback automático.
                listaItensTexto.append("- Data: ").append(valorComoTexto(linha.get("request_date"))).append("\n");
                listaItensTexto.append("  Solicitante: ").append(valorComoTexto(linha.get("solicitante_email"))).append("\n");
                listaItensTexto.append("  Link de decisao: ").append(valorComoTexto(linha.get("link_decisao_direta"))).append("\n\n");
                itensNoLote++;
        }

        // Envia o último lote
        if (!currentDestinatario.equals("")) {
            enviarLote(context, currentDestinatario, listaItensHtml.toString(), listaItensTexto.toString(), itensNoLote);
            countEmailsEnviados++;
            enviosHtml.append("<li>Lote final enviado para <b>")
                     .append(escaparHtml(currentDestinatario))
                     .append("</b></li>");
        } else {
            enviosHtml.append("<li>Nenhum envio realizado</li>");
        }

        adicionarItemRelatorio(etapasHtml, "Processamento finalizado com sucesso");

        out.println("<div style='max-width:1100px;margin:20px auto;padding:20px;border:1px solid #d8dee6;background:#f7fafc;font-family:Segoe UI,Tahoma,Arial,sans-serif;color:#1f2937;line-height:1.45;'>");
        out.println("<h2 style='margin:0 0 16px 0;font-size:24px;color:#0f172a;'>Relatorio detalhado da execucao</h2>");

        out.println("<div style='display:flex;flex-wrap:wrap;gap:12px;margin-bottom:16px;'>");
        out.println("<div style='flex:1;min-width:220px;background:#ffffff;border:1px solid #dbe4ee;padding:12px;'><b>Modo teste</b><br>" + (modoTeste ? "Sim" : "Nao") + "</div>");
        out.println("<div style='flex:1;min-width:220px;background:#ffffff;border:1px solid #dbe4ee;padding:12px;'><b>Registros processados</b><br>" + countRegistros + "</div>");
        out.println("<div style='flex:1;min-width:220px;background:#ffffff;border:1px solid #dbe4ee;padding:12px;'><b>E-mails enviados</b><br>" + countEmailsEnviados + "</div>");
        out.println("</div>");

        out.println("<h3 style='margin:18px 0 8px 0;color:#1e3a8a;'>Etapas executadas</h3><ul style='margin:0 0 0 18px;padding:0;'>" + etapasHtml.toString() + "</ul>");

        out.println("<h3 style='margin:18px 0 8px 0;color:#1e3a8a;'>Registros processados</h3>");
        if (countRegistros > 0) {
            out.println("<ul style='margin:0 0 0 18px;padding:0;'>" + itensHtml.toString() + "</ul>");
        } else {
            out.println("<p style='margin:0;'>Nenhum registro retornado pela consulta.</p>");
        }

        out.println("<h3 style='margin:18px 0 8px 0;color:#1e3a8a;'>Envios realizados</h3><ul style='margin:0 0 0 18px;padding:0;'>" + enviosHtml.toString() + "</ul>");

        out.println("<h3 style='margin:18px 0 8px 0;color:#1e3a8a;'>SQL executada</h3><pre style='margin:0;background:#0b1220;color:#e5e7eb;border:1px solid #243044;padding:12px;overflow:auto;white-space:pre-wrap;'>" + escaparHtml(sql) + "</pre>");
        out.println("</div>");
        context.complete();

    } catch (Exception e) {
        adicionarItemRelatorio(etapasHtml, "Erro encontrado: " + e.getClass().getSimpleName());
        out.println("<div style='max-width:1100px;margin:20px auto;padding:20px;border:1px solid #f3c5c5;background:#fff7f7;font-family:Segoe UI,Tahoma,Arial,sans-serif;color:#3f1d1d;line-height:1.45;'>");
        out.println("<h2 style='margin:0 0 12px 0;color:#9f1239;'>Relatorio detalhado da execucao</h2>");
        out.println("<p style='margin:0 0 10px 0;'><b>Erro no processamento:</b> " + escaparHtml(e.getMessage()) + "</p>");
        out.println("<h3 style='margin:12px 0 8px 0;color:#7f1d1d;'>Etapas executadas ate o erro</h3><ul style='margin:0 0 0 18px;padding:0;'>" + etapasHtml.toString() + "</ul>");
        out.println("</div>");
        e.printStackTrace();
    } finally {
        if (context.isValid()) context.abort();
    }
%>

<%! 
    private void adicionarItemRelatorio(StringBuilder destino, String mensagem) {
        destino.append("<li>")
               .append(escaparHtml(mensagem))
               .append("</li>");
    }

    private String escaparHtml(String valor) {
        if (valor == null) {
            return "";
        }
        return valor.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    private Connection obterConexaoJdbc(Context ctx) throws Exception {
        Object dbConnection = null;
        try {
            java.lang.reflect.Method getDbConnection = ctx.getClass().getMethod("getDBConnection");
            dbConnection = getDbConnection.invoke(ctx);
        } catch (NoSuchMethodException ex) {
            java.lang.reflect.Method getDbConnection = ctx.getClass().getDeclaredMethod("getDBConnection");
            getDbConnection.setAccessible(true);
            dbConnection = getDbConnection.invoke(ctx);
        }

        if (dbConnection == null) {
            throw new RuntimeException("Nao foi possivel obter conexao DB do Context");
        }

        if (dbConnection instanceof Connection) {
            return (Connection) dbConnection;
        }

        Object jdbcConnection = null;
        String[] metodosCandidatos = new String[] {
            "getConnection",
            "getJdbcConnection",
            "getInternalConnection",
            "getWrappedConnection"
        };

        for (int i = 0; i < metodosCandidatos.length && jdbcConnection == null; i++) {
            jdbcConnection = invocarMetodoSemParametrosSilenciosamente(dbConnection, metodosCandidatos[i]);
        }

        if (jdbcConnection == null) {
            java.lang.reflect.Method[] metodos = dbConnection.getClass().getMethods();
            for (int i = 0; i < metodos.length && jdbcConnection == null; i++) {
                java.lang.reflect.Method metodo = metodos[i];
                if (metodo.getParameterTypes().length == 0 && Connection.class.isAssignableFrom(metodo.getReturnType())) {
                    jdbcConnection = metodo.invoke(dbConnection);
                }
            }
        }

        if (jdbcConnection == null) {
            java.lang.reflect.Method[] metodos = dbConnection.getClass().getDeclaredMethods();
            for (int i = 0; i < metodos.length && jdbcConnection == null; i++) {
                java.lang.reflect.Method metodo = metodos[i];
                if (metodo.getParameterTypes().length == 0 && Connection.class.isAssignableFrom(metodo.getReturnType())) {
                    metodo.setAccessible(true);
                    jdbcConnection = metodo.invoke(dbConnection);
                }
            }
        }

        if (jdbcConnection == null) {
            java.lang.reflect.Field[] campos = dbConnection.getClass().getDeclaredFields();
            for (int i = 0; i < campos.length && jdbcConnection == null; i++) {
                java.lang.reflect.Field campo = campos[i];
                if (Connection.class.isAssignableFrom(campo.getType())) {
                    campo.setAccessible(true);
                    jdbcConnection = campo.get(dbConnection);
                }
            }
        }

        if (!(jdbcConnection instanceof Connection)) {
            throw new RuntimeException("Nao foi possivel obter java.sql.Connection a partir do Context/DBConnection");
        }
        return (Connection) jdbcConnection;
    }

    private List executarConsultaPendencias(Context ctx, String sql, StringBuilder etapasHtml) throws Exception {
        try {
            List linhas = executarConsultaViaJdbc(ctx, sql);
            adicionarItemRelatorio(etapasHtml, "Consulta executada no banco (via JDBC)");
            return linhas;
        } catch (Exception eJdbc) {
            adicionarItemRelatorio(etapasHtml, "JDBC indisponivel no runtime, tentando via Hibernate");
            List linhas = executarConsultaViaHibernate(ctx, sql);
            adicionarItemRelatorio(etapasHtml, "Consulta executada no banco (via Hibernate SQL)");
            return linhas;
        }
    }

    private List executarConsultaViaJdbc(Context ctx, String sql) throws Exception {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List linhas = new ArrayList();
        try {
            conn = obterConexaoJdbc(ctx);
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Map linha = new HashMap();
                linha.put("request_date", rs.getTimestamp("request_date"));
                linha.put("solicitante_email", rs.getString("solicitante_email"));
                linha.put("link_decisao_direta", rs.getString("link_decisao_direta"));
                linha.put("email_decisao_direta", rs.getString("email_decisao_direta"));
                linhas.add(linha);
            }
            return linhas;
        } finally {
            fecharResultSetSilenciosamente(rs);
            fecharStatementSilenciosamente(stmt);
        }
    }

    private List executarConsultaViaHibernate(Context ctx, String sql) throws Exception {
        Object dbConnection = invocarMetodoSemParametrosSilenciosamente(ctx, "getDBConnection");
        if (dbConnection == null) {
            throw new RuntimeException("Nao foi possivel obter DBConnection para fallback Hibernate");
        }

        Object session = invocarMetodoSemParametrosSilenciosamente(dbConnection, "getSession");
        if (session == null) {
            throw new RuntimeException("Nao foi possivel obter Session Hibernate");
        }

        Object query = invocarMetodoComUmParametroSilenciosamente(session, "createSQLQuery", sql);
        if (query == null) {
            query = invocarMetodoComUmParametroSilenciosamente(session, "createNativeQuery", sql);
        }
        if (query == null) {
            throw new RuntimeException("Nao foi possivel criar query SQL na Session Hibernate");
        }

        Object resultado = invocarMetodoSemParametrosSilenciosamente(query, "list");
        if (!(resultado instanceof List)) {
            throw new RuntimeException("Retorno inesperado da consulta Hibernate");
        }

        List bruto = (List) resultado;
        List linhas = new ArrayList();
        for (int i = 0; i < bruto.size(); i++) {
            Object item = bruto.get(i);
            Object[] colunas;
            if (item instanceof Object[]) {
                colunas = (Object[]) item;
            } else {
                colunas = new Object[] { item };
            }

            Map linha = new HashMap();
            linha.put("request_date", colunas.length > 0 ? colunas[0] : null);
            linha.put("solicitante_email", colunas.length > 1 ? colunas[1] : null);
            linha.put("link_decisao_direta", colunas.length > 3 ? colunas[3] : null);
            linha.put("email_decisao_direta", colunas.length > 4 ? colunas[4] : null);
            linhas.add(linha);
        }
        return linhas;
    }

    private String valorComoTexto(Object valor) {
        return valor == null ? "" : valor.toString();
    }

    private Object invocarMetodoSemParametrosSilenciosamente(Object alvo, String nomeMetodo) {
        try {
            java.lang.reflect.Method m = alvo.getClass().getMethod(nomeMetodo);
            return m.invoke(alvo);
        } catch (Exception e1) {
            try {
                java.lang.reflect.Method m = alvo.getClass().getDeclaredMethod(nomeMetodo);
                m.setAccessible(true);
                return m.invoke(alvo);
            } catch (Exception e2) {
                return null;
            }
        }
    }

    private Object invocarMetodoComUmParametroSilenciosamente(Object alvo, String nomeMetodo, String parametro) {
        try {
            java.lang.reflect.Method m = alvo.getClass().getMethod(nomeMetodo, String.class);
            return m.invoke(alvo, parametro);
        } catch (Exception e1) {
            try {
                java.lang.reflect.Method m = alvo.getClass().getDeclaredMethod(nomeMetodo, String.class);
                m.setAccessible(true);
                return m.invoke(alvo, parametro);
            } catch (Exception e2) {
                return null;
            }
        }
    }

    private void fecharResultSetSilenciosamente(ResultSet rs) {
        if (rs == null) {
            return;
        }
        try {
            rs.close();
        } catch (Exception ignore) {
            // Ignora erro de fechamento.
        }
    }

    private void fecharStatementSilenciosamente(Statement stmt) {
        if (stmt == null) {
            return;
        }
        try {
            stmt.close();
        } catch (Exception ignore) {
            // Ignora erro de fechamento.
        }
    }

    private String montarFraseOrientacao(int quantidadeItens) {
        if (quantidadeItens == 1) {
            return "Por favor, acesse o link acima para deferir ou indeferir o pedido.";
        }
        return "Por favor, acesse os links acima para deferir ou indeferir os pedidos.";
    }

    private boolean forcarEmailHtmlSeDisponivel(Email email) {
        try {
            java.lang.reflect.Method m = email.getClass().getMethod("setContentType", String.class);
            m.invoke(email, "text/html; charset=UTF-8");
            return true;
        } catch (Exception ignore) {
            // Alguns ambientes DSpace nao expõem esse método.
            return false;
        }
    }

    // Função auxiliar para disparar o e-mail usando o motor do DSpace
    private void enviarLote(Context ctx, String para, String conteudoHtml, String conteudoTexto, int quantidadeItens) throws Exception {
        Email email = Email.getEmail(I18nUtil.getEmailFilename(ctx.getCurrentLocale(), "solicitacao_pendente"));
        boolean htmlAtivo = forcarEmailHtmlSeDisponivel(email);
        if (!htmlAtivo) {
            email = Email.getEmail(I18nUtil.getEmailFilename(ctx.getCurrentLocale(), "solicitacao_pendente_texto"));
        }

        email.addRecipient(para);
        email.addArgument(para); // {0} Nome/Email da Unidade
        if (htmlAtivo) {
            email.addArgument("<ul style='padding-left:18px;margin:0;list-style:disc;'>" + conteudoHtml + "</ul>"); // {1} Bloco de itens
        } else {
            email.addArgument(conteudoTexto); // {1} Bloco de itens
        }
        email.addArgument(montarFraseOrientacao(quantidadeItens)); // {2} Frase singular/plural
        email.send();
    }
%>