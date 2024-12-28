var montharray=new Array("01","02","03","04","05","06","07","08","09","10","11","12");


var mydate=new Date();
var year=mydate.getYear();
if ( year < 1900 );
year+=1900;
var day=mydate.getDay();
var month=mydate.getMonth();
var daym=mydate.getDate();

//change font size here
var cdate=""+daym+"/"+montharray[month]+"/"+year+""

function FDate(input_data){
    $(input_data).val(cdate)
}


function NovoCliente(){
window.open('/personas/new?form=resumido', '', ' SCROLLBARS=NO, TOP=0, LEFT=190, WIDTH=660, HEIGHT=690');
}

function NovoProv(){
window.open('/personas/new?form=resumido_prov', '', ' SCROLLBARS=NO, TOP=0, LEFT=190, WIDTH=660, HEIGHT=690');
}

$(document).ready(function() {

    //mostra div dados cheque(diferido/nr cheque)
    $('.mosta_cheque').click(function() {
        if( $(this).is(':checked')) {
            $(".div_cheque").show();
        } else {
            $(".div_cheque").hide();
        }
    });

    //letra maiuscula nas inputs
    $('input:text').keyup(function() {
        $(this).val($(this).val().toUpperCase());
    });

    $("input[type=number]").focus(function(){
      this.select();
    });

    $("input[type=telephone]").focus(function(){
      this.select();
    });

    $("input[type=tel]").focus(function(){
      this.select();
    });



    $( "#inicio" ).datepicker({
      format: "dd/mm/yyyy",
      autoHide: true,
      locale: 'pt-br'
    });
    $( "#final" ).datepicker({
    	format: "dd/mm/yyyy",
      autoHide: true,
      locale: 'pt-br'
    });

    $( ".date" ).datepicker({
      showOn: "button",
      format: "dd/mm/yyyy",
      autoHide: true,
      locale: 'pt-br'
    });

    $( ".date-format" ).datepicker({
      showOn: "button",
      format: "dd/mm/yyyy",
      autoHide: true,
      locale: 'pt-br'
    });

});


function Formatadata(Campo, teclapres)
{
    var tecla = teclapres.keyCode;
    var vr = new String(Campo.value);
    vr = vr.replace("/", "");
    vr = vr.replace("/", "");
    vr = vr.replace("/", "");
    tam = vr.length + 1;
    if (tecla != 8 && tecla != 8)
    {
        if (tam > 0 && tam < 2)
            Campo.value = vr.substr(0, 2) ;
        if (tam > 2 && tam < 4)
            Campo.value = vr.substr(0, 2) + '/' + vr.substr(2, 2);
        if (tam > 4 && tam < 7)
            Campo.value = vr.substr(0, 2) + '/' + vr.substr(2, 2) + '/' + vr.substr(4, 7);
    }
}


function ImputFocus(i){
    document.getElementById(i).focus();
}


function DataCotacao(d,m,y){
    document.getElementById("key").value = document.getElementById(d).value+'/'+ document.getElementById(m).value+'/'+document.getElementById(y).value;
}

function number_format( number, decimals, dec_point, thousands_sep ) {
    var n = number, c = isNaN(decimals = Math.abs(decimals)) ? 2 : decimals;
    var d = dec_point == undefined ? "," : dec_point;
    var t = thousands_sep == undefined ? "." : thousands_sep, s = n < 0 ? "-" : "";
    var i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", j = (j = i.length) > 3 ? j % 3 : 0;
    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
}


function UsToGsRs(ct,ctrs,us,gs,rs){
    var cambio = eval( parseFloat( document.getElementById(us).value.replace(/\./g, "").replace(",", ".") ) * parseFloat( document.getElementById(ct).value.replace(/\./g, "").replace(",", ".") ) ) ;
    document.getElementById(gs).value = ( number_format( cambio,0, ',', '.') )

    var cambiors = eval( parseFloat( document.getElementById(gs).value.replace(/\./g, "") ) / parseFloat( document.getElementById(ctrs).value.replace(/\./g, "").replace(",", ".") ) )  ;
    document.getElementById(rs).value = ( number_format( cambiors,2, ',', '.') )
}

function VRsToUsGs(ct,ctrs,rs,us,gs){
    var cam = eval( parseFloat( document.getElementById(rs).value.replace(/\./g, "").replace(",", ".") ) / parseFloat( document.getElementById(ct).value.replace(/\./g, "").replace(",", ".") ) ) ;
    document.getElementById(us).value = ( number_format( cam,2, ',', '.') )

    var cambiors = eval( parseFloat( document.getElementById(us).value.replace(/\./g, "").replace(",", ".") ) * parseFloat( document.getElementById(ctrs).value.replace(/\./g, "").replace(",", ".") ) )  ;
    document.getElementById(gs).value = ( number_format( cambiors,0, ',', '.') )
}

function VRPsToUsGs(ct,ctrs,rs,us,gs){
    if (parseFloat( document.getElementById(rs).value) == 0){
        var cam = eval( parseFloat( document.getElementById(us).value.replace(/\./g, "").replace(",", ".") ) * parseFloat( document.getElementById(ct).value.replace(/\./g, "").replace(",", ".") ) ) ;
        document.getElementById(rs).value = ( number_format( cam,2, ',', '.') )
    }

    var cambiors = eval( parseFloat( document.getElementById(us).value.replace(/\./g, "").replace(",", ".") ) * parseFloat( document.getElementById(ctrs).value.replace(/\./g, "").replace(",", ".") ) )  ;
    document.getElementById(gs).value = ( number_format( cambiors,0, ',', '.') )
}


function GsToUsRs(ct,ctrs,gs,us,rs){
    var cambio = eval( parseFloat( document.getElementById(gs).value.replace(/\./g, "") ) / parseFloat( document.getElementById(ct).value.replace(/\./g, "") ) )  ;
    document.getElementById(us).value = ( number_format( cambio,4, ',', '.') )

    var cambiors = eval( parseFloat( document.getElementById(gs).value.replace(/\./g, "") ) / parseFloat( document.getElementById(ctrs).value.replace(/\./g, "").replace(",", ".") ) )  ;
    document.getElementById(rs).value = ( number_format( cambiors,4, ',', '.') )
}


function RsToUsGs(ct,ctrs,gs,us,rs){
    var cambio = eval( parseFloat( document.getElementById(rs).value.replace(/\./g, "").replace(",", ".") ) * parseFloat( document.getElementById(ctrs).value.replace(/\./g, "") ) )  ;
    document.getElementById(gs).value = ( number_format( cambio,0, ',', '.') )

    var cambiors = eval( parseFloat( document.getElementById(gs).value.replace(/\./g, "") ) / parseFloat( document.getElementById(ct).value.replace(/\./g, "")) )  ;
    document.getElementById(us).value = ( number_format( cambiors,2, ',', '.') )
}

function QtdToTotUs(qtd,unit,tot)                                               //
{
        var result = eval( parseFloat( document.getElementById(qtd).value.replace(/\./g, "").replace(",", ".") ) ) * eval( parseFloat( document.getElementById(unit).value.replace(/\./g, "").replace(",", ".") ) )  ;
        document.getElementById(tot).value = ( number_format( result,2, ',', '.') )
}

function Tipo(d){
    document.getElementById('tipo').value = d
}

function UsToGs(ct,us,gs){
    var cambio = eval( parseFloat( document.getElementById(us).value.replace(/\./g, "").replace(",", ".") ) * document.getElementById(ct).value.replace(/\./g, "").replace(",", ".") )  ;
    document.getElementById(gs).value = ( number_format( cambio,0, ',', '.') )
}

function GsToUs(ct,gs,us){
    var cambio = eval( parseFloat( document.getElementById(gs).value.replace(/\./g, "") ) / document.getElementById(ct).value.replace(/\./g, "").replace(",", ".") )  ;
    document.getElementById(us).value = ( number_format( cambio,2, ',', '.') )
}

//euro para guarnai e dolar
function EuToUsGs(CtEuUs,CtEuGs,Eu,Us,Gs){
    var cambiors = eval( parseFloat( document.getElementById(Eu).value.replace(/\./g, "") ) * document.getElementById(CtEuUs).value.replace(/\./g, "").replace(",", ".") )  ;
    document.getElementById(Us).value = ( number_format( cambiors,2, ',', '.') )

    var cambio = eval( parseFloat( document.getElementById(Eu).value.replace(/\./g, "").replace(",", ".") ) * document.getElementById(CtEuGs).value.replace(/\./g, "").replace(",", ".") )  ;
    document.getElementById(Gs).value = ( number_format( cambio,0, ',', '.') )

}

//dolar para euro e guarani
function UsToEsGs(CtEuUs,CtGsUs,Eu,Us,Gs){
    var cambiors = eval( parseFloat( document.getElementById(Us).value.replace(/\./g, "") ) / document.getElementById(CtEuUs).value.replace(/\./g, "").replace(",", ".") )  ;
    document.getElementById(Eu).value = ( number_format( cambiors,2, ',', '.') )

    var cambio = eval( parseFloat( document.getElementById(Us).value.replace(/\./g, "").replace(",", ".") ) * document.getElementById(CtGsUs).value.replace(/\./g, "").replace(",", ".") )  ;
    document.getElementById(Gs).value = ( number_format( cambio,0, ',', '.') )

}

//dolar para euro e guarani
function GsToEsUs(CtEuGs,CtGsUs,Eu,Us,Gs,Rs,CtGsRs){
    var cambiors = eval( parseFloat( document.getElementById(Gs).value.replace(/\./g, "") ) / document.getElementById(CtEuGs).value.replace(/\./g, "").replace(",", ".") )  ;
    document.getElementById(Eu).value = ( number_format( cambiors,2, ',', '.') )

    var cambio = eval( parseFloat( document.getElementById(Gs).value.replace(/\./g, "").replace(",", ".") ) / document.getElementById(CtGsUs).value.replace(/\./g, "").replace(",", ".") )  ;
    document.getElementById(Us).value = ( number_format( cambio,2, ',', '.') )

    var cambio_rs = eval( parseFloat( document.getElementById(Gs).value.replace(/\./g, "").replace(",", ".") ) / document.getElementById(CtGsRs).value.replace(/\./g, "").replace(",", ".") )  ;
    document.getElementById(Rs).value = ( number_format( cambio_rs,2, ',', '.') )

}


//real para dolar e guarani
function RsToUsGs(CtRsUs,CtRsGs,Rs,Us,Gs){
    var cambiors = eval( parseFloat( document.getElementById(Rs).value.replace(/\./g, "") ) / document.getElementById(CtRsUs).value.replace(/\./g, "").replace(",", ".") )  ;
    document.getElementById(Us).value = ( number_format( cambiors,2, ',', '.') )

    var cambio = eval( parseFloat( document.getElementById(Rs).value.replace(/\./g, "").replace(",", ".") ) * document.getElementById(CtRsGs).value.replace(/\./g, "").replace(",", ".") )  ;
    document.getElementById(Gs).value = ( number_format( cambio,0, ',', '.') )

}
