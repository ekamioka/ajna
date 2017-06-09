<div id="fixed_width_content">
      
    <br>
    <center><img src="../image/ajna-small.jpg" alt="logo"></center>
    <br>

    <center><h2>AJNA</h2></center>
    <center><p>
    Agya (Sanskrit: आज्ञा, IAST: Agya, English: "command"), or Third-eye Chakra, is the sixth primary Chakra or energy point in the body,
    according to Hindu tradition. It is a part of the brain which can be made more powerful through repetition, like a muscle, and signifies the conscience.
    </p><br></center>

    
    <br>
    <center><h3>Application</h3></center>  
    <p>
    The platform Ajna is a functional prototype to help in the process of Exploratory Data Analysis.
    New functionalities and applications are comming soon. If you would like to see a functionality implemented, please
    feel free to fork the project or open an issue into the github project.
    
    <br><br>So far there is no target audience (business users, data analysts, etc.). It was created in the spare time during the last 2 days to explore R Shiny with Bootstrap. I think I will define the target on-the-fly. I just wanted to take it from the idea stage, implement and share as a skeleton, so people can build upon.
    
    <br><br>To test the tool, I suggest downloading and using this file:<a href="https://app.box.com/s/k8ucnya2ughr82g1wvhjq9fg47b6fduy" target="_blank"> wine.csv</a>
    
    <br><br>The file upload is limited to a size of 10MB because of my current hosting plan in Shinyapps. Therefore, I tested with files bigger than 500MB without crashes and freezes.
    </p>
    

    <br>
    <center><h3>Assumption</h3></center>  
    <p>
    1. We assume the file is in .csv format;<br>
    
    2. We assume that the first row in the file is the header;<br>
    
    3. We assume the data is already cleaned and converted to numerical, although categorical will be identified too. The descriptive statistics is 
    fully functional for numerical data and perhaps the graphs will not work properly with categorical, text, unstructured data and so on.
    </p>

    <br>
    <center><h3>Acknowledgement</h3></center>
    
    <p>Thanks to <a href="https://github.com/woobe/" target="_blank">Jo-fai Chow</a>'s
    <a href="https://github.com/woobe/rugsmaps/blob/master/doc/intro.md" target="_blank"><i>Maps of R User Groups Around the World project</i></a>, who inspired and provided
    the idea and code base to use Bootstrap and R Shiny.
    
    <p>Thanks to <a href="https://plot.ly/" target="_blank">Plotly</a>, for the state of the art in data viz, dashboards, and collaborative analysis.

    <p>The
    <a href="http://www.rstudio.com/" target="_blank">RStudio team</a>
    has provided the community two very powerful tools: 
    <a href="http://shiny.rstudio.com/" target="_blank"><i>Shiny</i></a> and
    <a href="https://www.shinyapps.io/" target="_blank"><i>ShinyApps</i></a>.
    These tools allow R users to quickly develop and to host web applications.</p>
    
    <p>The R developers that has provided the community very powerful libraries: 
    <a href="http://rmarkdown.rstudio.com/" target="_blank"><i>Markdown</i></a>, 
    <a href="https://cran.r-project.org/web/packages/data.table/index.html" target="_blank"><i>Data Table</i></a>,
    <a href="https://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html" target="_blank"><i>Corrplot</i></a>,
    <a href="https://rstudio.github.io/DT/" target="_blank"><i>DT</i></a>,
    <a href="https://cran.r-project.org/web/packages/GGally/index.html" target="_blank"><i>GGally</i></a>.</p>
    
    <p>The website <a href="http://whitecrowyoga.com/sixth-ajna-chakra-poses/" target="_blank"><i>White Crow Yoga</i></a>, where I found the beautiful image 
    of Ajna Chakra 96 Petal Lotus. 
    <br>
    
    <center><h3>License</h3></center>
    <p>
    This app comes with the
    <a href="https://opensource.org/licenses/MIT" target="_blank">
    MIT License (MIT)</a>.
    <p>
    
    <script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-82435609-1', 'auto');
  ga('send', 'pageview');

  </script>


</div>
