function ajax(url){
  $('#spinner').show();

  req = null;

  if (window.XMLHttpRequest) {

    req = new XMLHttpRequest();
    req.onreadystatechange = processReqChange;
    req.open("GET",url,true);
    req.send(null);


  } else if (window.ActiveXObject) {

    req = new ActiveXObject("Microsoft.XMLHTTP");

    if (req){
      req.onreadystatechange = processReqChange;
      req.open("GET",url,true);
      req.send();
    }
  }
}

function processReqChange(){
  if (req.readyState == 4) {
    if (req.status ==200) {
        onSuccess:$('#spinner').hide();
        document.getElementById('pagina').innerHTML = req.responseText;
    } else {
        alert("Houve um problema ao obter os dados:n" + req.statusText);
    }
  }
}

$(function () {
    $("#pagina").on("click", ".pagination a", function () {
        $.ajax({
        method: "get",
        url: this.href,
        beforeSend: function(){
        $("#spinner").show("fast");
        },
        success: function(retorno){
        $('#spinner').hide("slow");
        $("#pagina").html(retorno).fadeIn( "slow" );
        }
        });
        return false;
      }
    );
  });
