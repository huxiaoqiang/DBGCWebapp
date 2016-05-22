$(document).ready(function(){
    function readCookie(name) {
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for(var i=0;i < ca.length;i++) {
            var c = ca[i];
            while (c.charAt(0)==' ')
                c = c.substring(1,c.length);
            if (c.indexOf(nameEQ) == 0)
                return c.substring(nameEQ.length,c.length);
        }
        return null;
    };
    var files;
    var fileNames = '';
    $('input[type=file]').on('change',preUpload);
    $('input[type=radio]').on('change',toggleChoice);
    var radio = readCookie("radio");
    setRadio(radio);
    $(".loading").hide();
    function preUpload(event){
        files = event.target.files;
        for(i = 0; i < files.length; i++){
            fileNames = fileNames + files[i].name + '  ';
        }
        $('.uploadFileText').val(fileNames);
        uploadFiles(event);
    };
    $('#UploadFileForm').on('submit', uploadFiles);
    function uploadFiles(event){
        event.stopPropagation(); // Stop stuff happening
        event.preventDefault(); // Totally stop stuff happening
        var data = new FormData();
        $.each(files,function(key,value){
            data.append(key,value);
        });
        var csrftoken = readCookie('csrftoken');
        data.append('csrfmiddlewaretoken',csrftoken);
        $('.loader').css("display","block");
        $('.fileUpload').css("display","none");
        $('.example').css("float","right");
        $.ajax({
            url:'api/file/upload',
            type: 'POST',
            data: data,
            cache:false,
            dataType: 'json',
            processData: false, // Don't process the files
            contentType: false, // Set content type to false as jQuery will tell the server its a query string request
            success:function(data,textStatus,jqXHR){
                if(data.error.code == '1'){
                    window.location.href = '/output/';
                    console.log('success!');
                }
                else if(data.error.code >= 101){
                    window.location.href = '/';
                    alert("Error " + data.error.code + "! " + data.error.errMsg);
                    console.log(data.error.code + " " + data.error.errMsg);
                }
                else{
                    console.log(data.error.code);
                }
            },
            error:function(data,textStatus,jqXHR){
                console.log(data);
            }
        });
    };
    function setRadio(radio){
        if(radio=='file' || radio == null){
            $("#UploadStringForm").hide();
            $("#UploadFileForm").show();
            $(".file")[0].checked = true;
            $(".string")[0].checked = false;
        }
        else{
            $("#UploadStringForm").show();
            $("#UploadFileForm").hide();
            $(".string")[0].checked = true;
            $(".file")[0].checked = false;
        }
    }
    function toggleChoice(event){
        if($('input:radio:checked').val()=='file'){
            $("#UploadStringForm").hide();
            $("#UploadFileForm").show();
            setCookie("radio","file");
        }
        else{
            $("#UploadStringForm").show();
            $("#UploadFileForm").hide();
            setCookie("radio","string");
        }
    };
    $('#UploadStringForm').on('submit', submitStr);
    function submitStr(){
        $(".submitString").hide();
        $(".loading").show();
        event.stopPropagation(); // Stop stuff happening
        event.preventDefault(); // Totally stop stuff happening
        var data = new FormData();
        var str = $('textarea').val();
        var csrftoken = readCookie('csrftoken');
        data.append('data',str);
        data.append('csrfmiddlewaretoken',csrftoken); 
        $.ajax({
            url:'api/str/upload',
            type: 'POST',
            data: data,
            cache:false,
            dataType: 'json',
            processData: false, // Don't process the files
            contentType: false, // Set content type to false as jQuery will tell the server its a query string request
            success:function(data,textStatus,jqXHR){
                if(data.error.code == '1'){
                    window.location.href = '/output/';
                    console.log('success!');
                }
                else if(data.error.code >= 101){
                    window.location.href = '/';
                    alert("Error " + data.error.code + "! " + data.error.errMsg);
                    console.log(data.error.code + " " + data.error.errMsg);
                }
                else{
                    console.log(data.error.code);
                }
            },
            error:function(data,textStatus,jqXHR){
                console.log(data);
            }
        });
    };
});
//JS操作cookies方法!
//写cookies
function setCookie(name,value)
{
    var Days = 30;
    var exp = new Date();
    exp.setTime(exp.getTime() + Days*24*60*60*1000);
    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
}