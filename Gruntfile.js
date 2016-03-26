module.exports = function(grunt){

    //project configration
    grunt.initConfig({
        pkg : grunt.file.readJSON('package.json'),
        less : {
            development:{
                options:{
                    paths:['./static/less'],
                    compress: true
                },
                files:{
                    './static/css/base.css':'./static/less/base.less'
                }
            }
        }
    });
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.registerTask('default',['less']);
};