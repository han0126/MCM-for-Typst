#import "../template/template.typ": *

= 符号说明
#figure(
  table(
    columns: (1fr,1fr),
    align: horizon + center,
    stroke: none,
    table.hline(stroke: 1.5pt),
    table.header(
      [符号],[说明]
    ),
    table.hline(stroke: 0.8pt),
    [$a_0$],[线性回归方程常数项],
    [$a_1$],[线性回归方程一次项],
    [$a_2$],[线性回归方程二次项],
    [$b_1$],[非线性回归方程分子一次项],
    [$b_2$],[非线性回归方程分子常数项], 
    [$b_3$],[非线性回归方程分母常数项], 
    table.hline(stroke: 1.5pt),
  )
)