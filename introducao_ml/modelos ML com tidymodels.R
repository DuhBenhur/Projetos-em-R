#Treinando vários modelos de Machine Learning
#Pacotes utilizados
pacotes <- c("plotly","tidyverse","ggrepel","fastDummies","knitr","kableExtra",
             "splines","reshape2","PerformanceAnalytics","metan","correlation",
             "see","ggraph","nortest","rgl","car","olsrr","jtools","ggstance",
             "magick","cowplot","beepr","Rcpp","tidymodels",
             "glmnet","nnet","kernlab","rpart","ranger","xgboost")

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}


load(file = "paises.RData")

#Estatísticas univariadas
summary(paises)

#Gráfico 3D com scatter
scatter3d(cpi ~ idade + horas,
          data = paises,
          surface = F,
          point.col = "#440154FF",
          axis.col = rep(x = "black",
                         times = 3))

##################################################################################
#                               ESTUDO DAS CORRELAÇÕES                           #
##################################################################################
#Visualizando a base de dados
paises %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = F, 
                font_size = 20)

#A função correlation do pacote correlation faz com que seja estruturado um
#diagrama interessante que mostra a inter-relação entre as variáveis e a
#magnitude das correlações entre elas
#Requer instalação e carregamento dos pacotes see e ggraph para a plotagem
paises %>%
  correlation(method = "pearson") %>%
  plot()

#A função chart.Correlation() do pacote PerformanceAnalytics apresenta as
#distribuições das variáveis, scatters, valores das correlações e suas
#respectivas significâncias
chart.Correlation((paises[2:4]), histogram = TRUE)

##################################################################################
#     ESTIMANDO UM MODELO MÚLTIPLO COM AS VARIÁVEIS DA BASE DE DADOS paises      #
##################################################################################
#Estimando a Regressão Múltipla
modelo_paises <- lm(formula = cpi ~ . - pais,
                    data = paises)

#Parâmetros do modelo
summary(modelo_paises)
confint(modelo_paises, level = 0.95) # siginificância de 5%

#Outro modo de apresentar os outputs do modelo - função summ do pacote jtools
summ(modelo_paises, confint = T, digits = 3, ci.width = .95)
export_summs(modelo_paises, scale = F, digits = 5)

#Salvando os fitted values na base de dados
paises$cpifit <- modelo_paises$fitted.values

#Gráfico 3D com scatter e fitted values
scatter3d(cpi ~ idade + horas,
          data = paises,
          surface = T, fit = "linear",
          point.col = "#440154FF",
          axis.col = rep(x = "black",
                         times = 3))


splits <- paises %>% 
  initial_split(strata = cpi)

paises_train <- training(splits)
paises_test <- testing(splits)


#Recipes

recipe_normalized <- recipe(
  cpi ~ idade + horas,
  data = paises
) %>% 
  step_normalize((all_predictors()))

recipe_simple <- recipe(
  cpi ~ idade + horas,
  data = paises
)



#Modelos
#Regressão Linear
reg_model <- linear_reg(penalty = tune(), mixture = tune()) %>% 
  set_engine("glmnet") %>% 
  set_mode("regression")

#Rede Neural - Multilayer perceptron
nn_model <- mlp(hidden_units = tune(), penalty = tune(), epochs = tune()) %>% 
  set_engine("nnet") %>% 
  set_mode("regression")


# SVM
svm_model <- svm_linear(cost = tune(), margin = tune()) %>% 
  set_engine("kernlab") %>% 
  set_mode("regression")

#Decision Tree

dt_model <- decision_tree(
  cost_complexity = tune(), min_n = tune()
) %>% 
  set_engine("rpart") %>% 
  set_mode("regression")
)

# Random Forest

rf_model <- rand_forest(
  mtry = tune(), min_n = tune(), trees = 1000
) %>% 
  set_engine("ranger") %>% 
  set_mode("regression")



xgb_model <- boost_tree(
  tree_depth = tune(), learn_rate = tune(),
  loss_reduction = tune(), min_n = tune(),
  sample_size = tune(), trees = tune()
) %>% 
  set_engine("xgboost") %>% 
  set_mode("regression")



#workflow

normalized <- workflow_set(
  preproc = list(normalized = recipe_normalized),
  models = list(reg_linear = reg_model,
                neural_network = nn_model,
                svm = svm_model)
)


simple <- workflow_set(
  preproc = list(simple = recipe_simple),
  models = list(decision_tree = dt_model,
                rand_forest = rf_model,
                xgboost = xgb_model)
)


complete_workflows <- bind_rows(normalized, simple) %>% 
  mutate(
    wflow_id = gsub("(simple_)|(normalized_)","",wflow_id)
  )


#Treinamento do modelo

cv_splits <- vfold_cv(
  paises_train, v = 10, strata = cpi
)

grid_ctrl <- control_grid(
  save_pred =  TRUE,
  parallel_over = "everything",
  save_workflow = TRUE
)


grid_results <- complete_workflows %>% 
  workflow_map(
    resamples = cv_splits,
    grid = 15,
    control = grid_ctrl
  )


autoplot(grid_results)
autoplot(grid_results, id = "rand_forest")

autoplot(grid_results,
         rank_metric = "rmse",
         metric = "rmse",
         select_best = TRUE)
