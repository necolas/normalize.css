module.exports = function(grunt){
  grunt.initConfig({

    pkg: grunt.file.readJSON("package.json"),

    cssmin: {
      target: {
        files: [{
          expand: true,
          cwd: './',
          src: ['*.css', '!*.min.css'],
          dest: './',
          ext: '.min.css'
        }]
      }
    }

  });
  grunt.loadNpmTasks("grunt-contrib-cssmin");
};
