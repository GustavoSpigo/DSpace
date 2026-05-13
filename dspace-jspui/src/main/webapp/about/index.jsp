<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@page import="java.util.Set"%>
<% 
    String layoutNavbar = "default";
%>
<dspace:layout titlekey="browse.page-title" navbar="<%=layoutNavbar %>">

<style>
    /* Estilos customizados para a página Sobre o RIC-CPS */
    .ric-institucional {
        font-family: 'Open Sans', Arial, Helvetica, sans-serif;
        color: #333333;
        line-height: 1.6;
        padding: 20px 15px;
    }
    .ric-institucional h3 {
        color: #222222;
        font-size: 26px;
        border-bottom: 2px solid #a30000; /* Vermelho CPS */
        padding-bottom: 10px;
        margin-bottom: 25px;
        font-weight: 600;
    }
    .ric-institucional h4 {
        color: #a30000; /* Vermelho CPS para os subtítulos */
        font-size: 20px;
        margin-top: 35px;
        margin-bottom: 15px;
        font-weight: 600;
    }
    .ric-institucional h5 {
        color: #444444;
        font-size: 16px;
        font-weight: bold;
        margin-top: 25px;
        margin-bottom: 15px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .ric-institucional p {
        margin-bottom: 15px;
        text-align: justify;
    }
    .ric-institucional a {
        color: #a30000;
        text-decoration: none;
        font-weight: 600;
        word-break: break-all;
    }
    .ric-institucional a:hover {
        text-decoration: underline;
        color: #7a0000;
    }
    .ric-institucional ol {
        margin-bottom: 20px;
        padding-left: 20px;
    }
    .ric-institucional ol li {
        margin-bottom: 10px;
        text-align: justify;
    }
    /* Estilo para as listas de equipe em formato de cards sutis */
    .equipe-list {
        list-style-type: none;
        padding-left: 0;
        margin-bottom: 30px;
    }
    .equipe-list li {
        background: #fdfdfd;
        padding: 12px 18px;
        margin-bottom: 10px;
        border-left: 4px solid #a30000;
        border-radius: 0 4px 4px 0;
        box-shadow: 0 1px 3px rgba(0,0,0,0.05);
    }
    .equipe-list strong {
        color: #111111;
        font-size: 1.05em;
        display: block;
        margin-bottom: 3px;
    }
    /* Estilo para a lista de documentos e referências */
    .doc-list {
        list-style-type: none;
        padding-left: 0;
    }
    .doc-list li {
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 1px solid #eeeeee;
    }
    .doc-list li:last-child {
        border-bottom: none;
    }
</style>

   <div class="largura-maxima ric-institucional" style="margin:auto"> 
      
      <h3>Sobre o Repositório Institucional do Conhecimento do Centro Paula Souza (RIC-CPS)</h3>

      <h4>Apresentação</h4>
      <p>O Repositório Institucional do Conhecimento do Centro Paula Souza (RIC-CPS) é uma ferramenta informatizada capaz de gerenciar, armazenar, preservar e disseminar em formato digital o conhecimento científico, tecnológico, artístico-cultural e técnico-administrativo produzido nas comunidades do Centro Paula Souza.</p>
      <p>Ao lançarem mão dessa ferramenta, as Faculdades de Tecnologia (Fatecs) e as Escolas Técnicas Estaduais (Etecs) contam com o apoio institucional e tecnológico necessário para:</p>
      <ol>
         <li>garantir o acesso, a gestão e a preservação da produção científica, tecnológica, artística-cultural e técnico-administrativa;</li>
         <li>permitir ampla disseminação do conhecimento acadêmico e técnico-administrativo produzido nas instituições;</li>
         <li>potencializar e promover intercâmbios na tríade ensino, pesquisa e extensão;</li>
         <li>contribuir com os projetos de internacionalização através da disseminação do conhecimento em âmbito nacional e internacional;</li>
         <li>reconhecer e valorizar as competências e os esforços das comunidades discente, docente e técnico-administrativa;</li>
         <li>entender que os maiores benefícios do investimento público numa oferta educacional devem ser para o cidadão e para o profissional bem formado, através do conhecimento produzido e transmitido nas instituições de ensino.</li>
      </ol>

      <h4>Objetivo</h4>
      <p>Implementar no âmbito institucional do Centro Paula Souza uma ferramenta informatizada unificada de código aberto capaz de gerenciar, armazenar, preservar e disseminar em formato digital o conhecimento científico, tecnológico, artístico-cultural e técnico-administrativo produzido nas comunidades do Centro Paula Souza.</p>
      <p>A ferramenta deve atender as unidades do Centro Paula Souza - FATECs e ETECs - no que diz respeito às suas demandas de gestão e preservação do conhecimento resultante da produção docente, discente e administrativa – Trabalhos de Conclusão de Curso, Artigos, Documentos Administrativos, Relatórios, Jogos Digitais etc.</p>

      <h4>Público-alvo</h4>
      <p>
         Professores, alunos, servidores e pesquisadores do Centro Paula Souza;<br>
         Comunidade acadêmica externa ao Centro Paula Souza.
      </p>

      <h4>Versão</h4>
      <p>• RIC-CSP-1.0 de 24 julho de 2020</p>

      <h4>Equipe</h4>

      <h5>Comitê Gestor do RIC-CPS (CG-RIC-CPS):</h5>
      <ul class="equipe-list">
         <li>
            <strong>Amneris Ribeiro Caciatori</strong>
            Representante da Coordenadoria Geral de Ensino Médio e Técnico (CGETEC) / Unidade de Ensino Médio e Técnico (Cetec)
         </li>
         <li>
            <strong>Ana Valquiria Niaradi</strong>
            Equipe de Biblioteconomia e Arquivologia (Equipe BiblioArq)
         </li>
         <li>
            <strong>Carla Aparecida Pedriali Moraes</strong>
            Representante da Coordenadoria Geral de Ensino Superior de Graduação / Unidade de Ensino Superior de Graduação (Cesu)
         </li>
         <li>
            <strong>Diana Espírito Santo</strong>
            Serviço de Documentação de Atos Oficiais e Normativos (SEDAON) / Núcleo de Documentação (ND)
         </li>
         <li>
            <strong>Douglas Hamilton de Oliveira</strong>
            Coordenadoria Geral de Tecnologia da Informação e Comunicação (CGTIC) / Divisão de Informática (DI)
         </li>
         <li>
            <strong>Fernanda Hellen de Sousa</strong>
            Equipe Técnica de Apoio do RIC-CPS (ETA-RIC-CPS)
         </li>
         <li>
            <strong>Humberto Celeste Innarelli</strong>
            Equipe Técnica Executiva do RIC-CPS (ETE-RIC-CPS)
         </li>
         <li>
            <strong>Luciana Domiciano Barreto</strong>
            Serviço de Gestão de Bibliotecas (SGB/DGUI) / Núcleo de Biblioteca (NB/CGD)
         </li>
         <li>
            <strong>Marilia Macorin de Azevedo</strong>
            Representante da Coordenadoria Geral de Pós-Graduação, Extensão e Pesquisa (CGPEP) / Unidade de Pós-Graduação, Extensão e Pesquisa (Upep)
         </li>
         <li>
            <strong>Tatiane Silva Massucato Arias</strong>
            Divisão de Gestão de Unidades de Informação (DGUI) / Centro de Gestão Documental (CGD)
         </li>
      </ul>

      <h5>Equipe Técnica Executiva do RIC-CPS:</h5>
      <ul class="equipe-list">
         <li>
            <strong>Humberto Celeste Innarelli</strong>
            Coordenador do projeto<br>Professor da Fatec de Campinas
         </li>
         <li>
            <strong>Gustavo Carvalho Gomes de Abreu</strong>
            Líder da Equipe de Técnica de Desenvolvimento (ETD)<br>Professor da Fatec Ministro Ralph Biasi (Americana)
         </li>
         <li>
            <strong>Ana Valquiria Niaradi</strong>
            Membro da Equipe de Biblioteconomia e Arquivologia (Equipe BiblioArq)<br>Bibliotecária da Fatec Ministro Ralph Biasi (Americana)
         </li>
         <li>
            <strong>Fernanda Hellen de Sousa</strong>
            Membro da Equipe de Biblioteconomia e Arquivologia (Equipe BiblioArq)<br>Professora da Etec de Hortolândia (Hortolândia)
         </li>
         <li>
            <strong>José William Pinto Gomes</strong>
            Colaborador da Equipe de Técnica de Desenvolvimento (ETD)<br>Professor da Fatec Ministro Ralph Biasi (Americana)
         </li>
         <li>
            <strong>Evandro Santaclara</strong>
            Membro da Equipe de Técnica de Desenvolvimento (ETD)<br>Professor da Fatec Ministro Ralph Biasi (Americana)
         </li>
      </ul>

      <h4>Documentos do RIC-CPS</h4>
      <ul class="doc-list">
         <li>
            <strong>PORTARIA CEETEPS-GDS N° 3013, de 27 de maio de 2021</strong>, institucionaliza o Repositório Institucional do Conhecimento do Centro Paula Souza (RIC - CPS) e <strong>PORTARIA CEETEPS-GDS Nº 3014, de 27 de maio de 2021</strong>, designa o Comitê Gestor do Repositório Institucional do Conhecimento do Centro Paula Souza (CG-RIC-CPS).<br>
            <a href="http://diariooficial.imprensaoficial.com.br/doflash/prototipo/2021/Junho/03/exec1/pdf/pg_0031.pdf" target="_blank">Acessar Documento</a>
         </li>
         <li>
            <strong>PORTARIA CEETEPS-GDS N° 3015, de 27 de maio de 2021</strong>, que estabelece os procedimentos de entrega dos Trabalhos de Conclusão de Curso às Etecs às Fatecs, para disponibilização no Repositório Institucional do Conhecimento do Centro Paula Souza (RIC - CPS).<br>
            <a href="http://diariooficial.imprensaoficial.com.br/doflash/prototipo/2021/Junho/03/exec1/pdf/pg_0032.pdf" target="_blank">Acessar Documento</a>
         </li>
         <li>
            <strong>PORTARIA CEETEPS-GDS Nº 3793, de 10 de novembro de 2023</strong>, Institui o Repositório Institucional do Conhecimento do Centro Paula Souza (RIC-CPS) e seu Comitê Gestor, no âmbito da Unidade de Pós-Graduação, Extensão e Pesquisa (Upep); da Unidade de Ensino Superior de Graduação (Cesu); da Unidade de Ensino Médio e Técnico (Cetec) e da Administração Central do Centro Estadual de Educação Tecnológica Paula Souza (Ceeteps).
         </li>
         <li>
            <strong>PORTARIA CEETEPS-GDS Nº 3794, de 09 de novembro de 2023</strong>, Designa o Comitê Gestor do Repositório Institucional do Conhecimento do Centro Paula Souza (CG-RIC-CPS).
         </li>
         <li>
            <strong>PORTARIA CEETEPS-GDS nº 4069, de 15 de julho de 2024</strong>, Estabelece os procedimentos de entrega dos Trabalhos de Conclusão de Curso (TCCs), dos cursos presenciais e a distância, no âmbito da Unidade de Ensino Médio e Técnico (Cetec) e da Unidade de Ensino Superior de Graduação (Cesu).
         </li>
         <li>
            <strong>Políticas de Submissão de TCC no RIC-CPS</strong> - Política com objetivo de estabelecer os procedimentos de gestão e submissão dos Trabalhos de Conclusão de Curso (TCCs) no RIC-CPS, tendo em vista sua implementação nas unidades de ensino do Centro Paula Souza (CPS).<br>
            <a href="https://dgui.cps.sp.gov.br/dguidocumentos/politicas-de-gestao-e-submissao-de-trabalhos-de-conclusao-de-curso-no-repositorio-institucional-do-conhecimento-ric-cps/" target="_blank">Acessar Material</a>
         </li>
      </ul>

      <h4>Repositórios Institucionais de Referência</h4>
      <ul class="doc-list">
         <li>
            Alice – Repository Open Access to Scientific Information from Embrapa<br>
            <a href="https://www.alice.cnptia.embrapa.br/" target="_blank">https://www.alice.cnptia.embrapa.br/</a>
         </li>
         <li>
            Biblioteca Digital da Produção Intelectual da Universidade de São Paulo<br>
            <a href="http://www.producao.usp.br/" target="_blank">http://www.producao.usp.br/</a>
         </li>
         <li>
            Repositório da Produção Científica e Intelectual da Unicamp<br>
            <a href="http://repositorio.unicamp.br/" target="_blank">http://repositorio.unicamp.br/</a>
         </li>
         <li>
            Repositório Institucional da UnB – RIUnB<br>
            <a href="http://repositorio.unb.br/" target="_blank">http://repositorio.unb.br/</a>
         </li>
         <li>
            Repositório Institucional da Universidade Federal da Bahia<br>
            <a href="https://repositorio.ufba.br/ri/" target="_blank">https://repositorio.ufba.br/ri/</a>
         </li>
         <li>
            Repositório Institucional Digital do Ibict<br>
            <a href="http://repositorio.ibict.br/" target="_blank">http://repositorio.ibict.br/</a>
         </li>
         <li>
            Repositório Institucional UNESP<br>
            <a href="https://repositorio.unesp.br/" target="_blank">https://repositorio.unesp.br/</a>
         </li>
         <li>
            Biblioteca Digital da FGV (Repositório de Teses-Dissertações-Objetos digitais)<br>
            <a href="http://bibliotecadigital.fgv.br/dspace/" target="_blank">http://bibliotecadigital.fgv.br/dspace/</a>
         </li>
      </ul>

   </div>
</dspace:layout>