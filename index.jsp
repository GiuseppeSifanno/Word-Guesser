<html lang="it">
    <%@ page import="java.util.*"%>
    <%@ page import="org.json.simple.*"%>
    <%@ page import="org.json.simple.parser.JSONParser"%>
    <%@ page import="org.json.simple.*"%>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Word guesser</title>

        <link rel="stylesheet" href="stile.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" 
            integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" 
            integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    </head>
    <body>
        <%! 
            String json = "{\"facile\":[{\"parola\":\"mela\",\"indizio\":\"cade dagli alberi\"},{\"parola\":\"albero\",\"indizio\":\"Da ossigeno a tutto il pianeta\"}],\"normale\":[{\"parola\":\"capitano\",\"indizio\":\"guida una squadra\"},{\"parola\":\"carbonara\",\"indizio\":\"piace ai romani\"}],\"difficile\":[{\"parola\":\"Supercalifragilistichespiralidoso\",\"indizio\":\"Troppo complicata da scrivere e leggere\"},{\"parola\":\"osteopata\",\"indizio\":\"Scrocchia le ossa\"}]}";
        %>
        <% 
            String username = (request.getParameter("nome") != null ? request.getParameter("nome") : null);
            String difficolta = request.getParameter("difficolta");
            if(username == null){
        %>
        
        <!--deve essere visualizzato solamente quando la parola da indovinare non è stata scelta-->
        <h1 class="text-center my-3">Word Guesser</h1>
        <h6 class="text-center">Seleziona la difficolta' ed inserisci il tuo nome prima di iniziare</h6>
        <div class="text-center">
            <form action="#" method="post">
                <div class="btn-group" data-toggle="buttons">
                    <label class="btn border-0">
                        <input type="radio" name="difficolta" value="facile" checked>
                        Facile
                    </label>
                    <label class="btn border-0">
                        <input type="radio" name="difficolta" value="normale">
                        Normale
                    </label>
                    <label class="btn border-0">
                        <input type="radio" name="difficolta" value="difficile">
                        Difficile
                    </label>
                </div>
                <div>
                    <label class="form-label label">
                        Inserisci il tuo nome
                        <input type="text" class="form-control border-2" name="nome" required>
                    </label>
                </div>
                <div class="btn-group" role="group" style="width: 15%">
                    <input type="submit" class="btn btn-sm btn-success rounded-1 w-50" name="Submit" id="invia" value="Invia">
                </div>
            </form>
        </div>
        <% } %>

        <%! 
            String parola;
            String indizio;
            JSONParser parser=new JSONParser();
        %>

        <%
            if(username != null){
                try{
                    Object obj= parser.parse(json);
                    JSONObject lista = (JSONObject) obj;
                    JSONArray parole = (JSONArray) lista.get(difficolta);
                    JSONObject parolaObj = (JSONObject) parole.get(new Random().nextInt(0, 2));
                    parola = (String) parolaObj.get("parola");
                    indizio = (String) parolaObj.get("indizio");
                }catch(Exception e){ e.printStackTrace();}
        %>

        <center>
            <div id="alert" style="visibility: hidden; width: fit-content" class="my-3">
                <div class="alert alert-dismissible fade show" role="alert" id="alertPanel">
                    <div id="messaggio"></div>
                    <div class="btn-group my-3 col-12 column-gap-2" role="group">
                        <button type="button" onclick="window.location.reload()" class="btn btn-sm btn-primary rounded-1 w-50" value="Gioca ancora" contenteditable="false">Gioca ancora</button>
                        <button onclick="window.location.replace('index.jsp')" class="btn btn-sm btn-success rounded-1 w-50" value="Torna al Menu'" contenteditable="false">Torna al menu'</button>
                    </div>
                    <button type="button" style="box-shadow: none;" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </div>
        </center>

        <!-- 
            deve essere visualizzato solamente quando i paramentri sono stati inseriti
            ed è stata scelta la parola da indovinare
        -->
        <div class="container text-center my-5">
            <h3>Digita in ogni casella la lettera</h3>
            <p>Dopo aver riempito tutti gli spazi premi invia</p>

            <form class="form-control shadow-lg border-1 my-2">
                <div class="row gap-2" id="ctn-input">
                    <!-- 
                        le input text devono essere generate in maniera automatica
                        dopo aver contato il numero di caratteri della parola scelta
                    -->
                    <% for (int i = 0; i < parola.length(); i++) { %>
                        <input type="text" maxlength="1" minlength="0" oninput="controlla()" required>
                    <% } %> 
                    <h5>Indizio: <%= indizio %> </h5>
                </div>
                <div class="btn-group my-3 col-12 column-gap-2" role="group" style="width: 30%">
                    <button type="button" class="btn btn-sm btn-success rounded-1 w-50 disabled" value="Invia" id="Submit" onclick = "verifica()" contenteditable="false">Invia</button>
                    <button type="reset" class="btn btn-sm btn-danger rounded-1 w-50" id="Reset" value="Cancella" style="margin: 0;" contenteditable="false">Cancella</button>
                </div>
            </form>
        </div>

        <% } %>
        <!-- controllo sulla parola con js e comparsa di alert -->
        <script>
            function controlla(){
                var sem = false;
                var listInput = document.getElementById("ctn-input").getElementsByTagName("input");
                for (const input of listInput) {
                    if(input.value != "") sem = true;
                    else sem = false;
                    console.log(sem);
                }
                if(sem){
                    document.getElementById("Submit").classList.remove("disabled");
                    document.getElementById("Submit").classList.add("active");
                } 
                else {
                    document.getElementById("Submit").classList.remove("active");
                    document.getElementById("Submit").classList.add("disabled");
                }
            }

            function verifica(){
                var listInput = document.getElementById("ctn-input").getElementsByTagName("input");
                var parolaSegreta = "<%= parola %>";
                var parolaInput = "";
                for (const input of listInput) {
                    parolaInput += input.value;
                    console.log(parolaInput);
                }
                if(parolaInput.toLowerCase() == parolaSegreta){
                    document.getElementById("alertPanel").classList.add("alert-success");
                    document.getElementById("messaggio").innerText = "Complimenti "+ "<%= username %>" + " hai vinto!";
                    document.getElementById("alert").style.visibility = "visible";
                }
                else {
                    document.getElementById("alertPanel").classList.add("alert-danger");
                    document.getElementById("messaggio").innerText = "Mi dispiace "+ "<%= username %>" + " ma la parola non e' quella, riprova!";
                    document.getElementById("alert").style.visibility = "visible";
                }
            }
        </script>
    </body>
</html>