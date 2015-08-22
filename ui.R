
library(shiny)

shinyUI(fluidPage(
  # Set the page title
  titlePanel("Application for Next Word Prediction"),
  
  sidebarPanel(
    textInput("entry",
              h5("Insert your text (or just a single word) below"),
              "To be or not to"),
    radioButtons("radio",
                 h5("Select the prediction algorithm"),
                 choices = list("Simple Back-off (recommended for faster results)" = 1, 
                                "Witten-Bell Interpolation (slow)" = 2, 
                                "Kneser-Ney Smoothing (the slowest)" = 3),
                 selected = 1),
    numericInput("n",
                 h5("Maximal number of results"),
                 value = 5, min = 1, max = 100),

    submitButton("Click for prediction"),
    br()
    
   ),
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Main",
                         p(''),
                         h4("Predicted Words"),
                         p("(lowercase output in decreasing order of 
                           estimated probability)"),
#                          p("Where you input a sentence in the topleft panel, then select the number of words you'd like to see, e.g. 3 words by default and try to find a smooth method for the n-gram model. Then press the SUBMIT button. You will see:"),
#                          p('your last input'),
                         
#                          tags$style(type='text/css', '#sent {background-color: rgba(0,0,255,0.10); color: blue;font-size:25px;}'), 
#                          h4(verbatimTextOutput("sent"),style = "color:green"),                               
#                          h6('AND'),
#                          p('suggested predictions:'),
                         tags$style(type='text/css', '#text {background-color: rgba(255,255,0,0.10); color: green;font-size:30px;}'),
                         span(h4(verbatimTextOutput('text'),style = "color:green"))                             
                         
                         ),
                tabPanel('About',
                         # h4("Preamble"),
                         p(""),
                         p('This Shiny application is presented within the framework of the 
                           Capstone project for', a("Data Science specialization", 
                                                    href =  "http://www.coursera.org/specialization/jhudatascience/"),
                           "introduced by Johns Hopkins University 
                           in collaboration with", a("SwiftKey",
                                                     href =  "http://swiftkey.com/"), "."),
                         p('The main goal of this program is prediction of the most probable word following a certain
                           sentence or a separate word. Three main algorithms of prediction are introduced here:
                           simple back-off model and two recursive interpolations: Witten-Bell and modified Kneser-Ney.'),
                         p('Although the last one is claimed to be the most precise it takes suffiently more
                           time for calculations than simple back-off algorithm. 
                           See panel References for more details.'),
                         p(''),
                         p('The text base used for statistic modeling can be 
                            downloaded', 
                           a('here.', 
                              href = 'http://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip')),
                         p('It contains 3 sources for US English text corpora: blogs,
                           news and twitter. The text random sample with 10% of initial
                           base was performed as follows:'),
                         p('1. Text was completely transformed to lowercase;'),
                         p('2. Punctuation, numbers, non-ASCII symbols were removed;'),
                         p('3. Profanity words were filtered.'),
                         p(''),
                         p('Then the performed text sample was tokenized
                           and', a('n-grams', 
                                   href = 'http://en.wikipedia.org/wiki/N-gram'),
                           'for n = 1, 2, 3, 4 were built. These n-grams were used for
                           statistical prediction models.')
                         

                         
                         
                ),
                
                tabPanel("References",
                         p(""),
                         p("The complete code in R for this application is stored on",
                           a('GitHub.', href = 'http://github.com/Vladimir-Sazontov/DataScienceCapstoneProject.git')),
                         p(""),
                         p("Here are some pdf-links on useful tutorials and articles devoted to algorithms of 
                           natural language processing:"),
                         p("1. Chen, Stanley F. and Goodman, Joshua. 1998. An Empirical Study of Smoothing Techniques for
                            Language Modeling.", style = "font-style: italic;", a("[pdf]",
                             href =  "http://www.speech.sri.com/projects/srilm/manpages/pdfs/chen-goodman-tr-10-98.pdf")),
                         p("2. Seymore, Kristie and Rosenfeld, Ronald. 1996. Scalable Trigram Backoff Language Models.",
                            style = "font-style: italic;",
                            a("[pdf]", href =  "http://www.cs.cmu.edu/~roni/papers/scalable-TR-96-139.pdf")),
                         p("3. Koerner, Martin. 2013. Implementation of Modified Kneser-Ney Smoothing 
                             on Top of Generalized Language Models for Next Word Prediction.", 
                             style = "font-style: italic;", a("[pdf]",
                             href =  "https://west.uni-koblenz.de/sites/default/files/BachelorArbeit_MartinKoerner.pdf")),
                         p("In addition I highly recommend:"),
                         p("1. Online course of", a("Natural Language Processing", 
                                                    href =  "http://www.coursera.org/course/nlp") , "by Stanford University
                           through Coursera.", style = "font-style: italic;"),
                         p("2.", a("StackOverflow", href =  "http://stackoverflow.com/"), 
                           "- the best question and answer site for programmers.", 
                           style = "font-style: italic;") 
                )
    ))
))