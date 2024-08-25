pacman::p_load(DescTools,
               ggpubr,
               ggsurvfit,
               naniar,
               plotly,
               psych,
               summarytools,
               survminer,
               treemap,
               VIM,
               visdat,
               webshot2)

pacman::p_load(gtsummary, flextable, huxtable, survival, survminer, ggsurvfit)

install.packages(
  "datapasta",
  repos = c(mm = "https://milesmcbain.r-universe.dev", getOption("repos")))
