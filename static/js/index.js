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

    function preUpload(event){
        files = event.target.files;
        for(i = 0; i < files.length; i++){
            fileNames = fileNames + files[i].name + '  ';
        }
        $('.uploadFileText').val(fileNames);
        uploadFiles(event);
    };
    $('form').on('submit', uploadFiles);
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
