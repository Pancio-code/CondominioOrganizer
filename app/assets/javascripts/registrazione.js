var auth=new Boolean(false);

function validaForm() {
    if(auth==false){
        alert("Inserisci correttamente i dati");
        document.getElementById("Form").action="";
    }
    if (document.myForm.remember.checked) {
        alert("Hai scelto di essere ricordato per i prossimi accessi");
    }
    if(document.myForm.inputEmail.value=="" || document.myForm.inputPassword.value==""){
        alert("inserire correttamente le proprie credenziali");
    }
}
function PasswTypeON(){
    document.getElementById("PasswAlert").style.display="block";
}
function PasswTypeOFF(){
    document.getElementById("PasswAlert").style.display="none";
}
function isPassw(){
    var password = document.getElementById("password").value;
    var al=document.getElementById("alert");
    var x=0;
    //controllo numeri
    var check=/[0-9]/;
    if(check.test(password)){
        x = x + 20;
    }
    else al.innerHTML="Inserisci dei numeri";
    //controllo minuscole
    var check2=/[a-z]/;
    if(check2.test(password)){
        x = x + 20;
    }
    else al.innerHTML="Inserisci delle minuscole";
    //controllo maiuscole
    var check3=/[A-Z]/;
    if(check3.test(password)){
        x = x + 20;
    }
    else al.innerHTML="Inserisci delle maiuscole";
    //controllo simboli
    var check4=/[$-/:-?{-~!"^_`\[\]]/;
    if(check4.test(password)){
        x = x + 20;
    }
    else al.innerHTML="Inserisci dei caratteri speciali";
    // controllo lunghezza (minore o uguale a 10 caratteri)
    if(password.length >=10){
        x = x + 20;
    }
    else al.innerHTML="La password deve avere lunghezza di almeno 10 caratteri";
    var check5=/\s\S/;
    if(check5.test(password)){
        al.innerHTML = "La password non deve contenere spazi bianchi";
    }
    if(x==100){
        auth=true;
        al.innerHTML="Password sicura"
        document.getElementById("alert").style.color="green";
    }
    
}
