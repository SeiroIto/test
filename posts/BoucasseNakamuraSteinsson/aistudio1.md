# 1 Data source

Here is the requested succinct example for Figure VII, followed by the rest of the tables and figures organized by the mathematical models used to generate them.

### **Requested Example**

**Figure VII (Productivity and Real Wages)**
*   **Data:** Real wages ($w_t$), Population ($l_t$)
*   **Equations:**
    *   $a_t = w_t + \alpha l_t - \phi$ (from 1)
    *   $a_t = \tilde{a}_t + \epsilon_{2t}$ (implicit in Section II, formulated in 6)
    *   $\tilde{a}_t = \mu + \tilde{a}_{t-1} + \epsilon_{1t}$ (2)
*   **Plots:** The permanent component of productivity ($\tilde{a}_t$) and actual real wages ($w_t$).
*   **Assumptions:** The permanent shock $\epsilon_{1t}$ and transitory noise $\epsilon_{2t}$ are assumed to be independently distributed over time. $\mu$ is allowed to have structural breaks.

***

### **Application to All Other Tables and Figures**

To avoid repeating the same math, the remaining figures and tables are grouped by the structural model they rely on.

#### **1. The Simple Model (Section II)**
*   **Used for:** Table I, Figure V, Figure VI
*   **Data:** Real wages ($w_t$), Population ($l_t$)
*   **Equations:** 
    *   $a_t = w_t + \alpha l_t - \phi$ (from 1)
    *   $a_t = \tilde{a}_t + \epsilon_{2t}$ (6)
    *   $\tilde{a}_t = \mu + \tilde{a}_{t-1} + \epsilon_{1t}$ (2)
*   **Plots/Estimates:** 
    *   **Table I:** Estimates average growth $\mu$.
    *   **Figure V:** Plots posterior probability of structural breaks in $\mu$.
    *   **Figure VI:** Plots the permanent component $\tilde{a}_t$.
*   **Assumptions:** $\epsilon_{1t} \sim \mathcal{N}(0, \sigma_{\epsilon_1}^2)$ and $\epsilon_{2t} \sim \mathcal{N}(0, \sigma_{\epsilon_2}^2)$ are assumed independent over time. 

#### **2. Full Malthusian Model: Constant $\alpha, \beta$ (Section III.A)**
*   **Used for:** Table IV ("Constant $\alpha, \beta$"), Figure X ("Constant $\alpha, \beta$")
*   **Data:** Real wages ($w_t$), Population ($n_t$), Days worked ($d_t$), Rates of return ($r_t$)
*   **Equations:**
    *   $a_t = (1-\beta)(w_t - \tilde{\phi}) + \alpha(d_t + n_t) + \beta \log(r_t + \delta)$ (from 8)
    *   $a_t = \tilde{a}_t + \epsilon_{2t}$ (6)
    *   $\tilde{a}_t = \mu + \tilde{a}_{t-1} + \epsilon_{1t}$ (7)
    *   $n_t - n_{t-1} = \omega + \gamma(w_{t-1} + d_{t-1}) + \xi_t$ (9)
    *   $\xi_t = \xi_{1t} + \xi_{2t}$ (10)
*   **Plots/Estimates:** $\mu$ (Table IV), $\tilde{a}_t$ (Figure X).
*   **Assumptions:** $\epsilon_{1t}$ and $\epsilon_{2t}$ are assumed independent. Population shocks consist of a rare plague mixture shock $\xi_{1t}$ (11) and a normal shock $\xi_{2t} \sim \mathcal{N}(0, \sigma_{\xi_2}^2)$, which are assumed independent. 

#### **3. Early Industrial Economy: Time-Varying $\alpha_t, \beta_t$ (Section III.B)**
*   **Used for:** Table IV ("Baseline"), Table V, Figure I, Figure X ("Baseline"), Figure XI, Figure XIII, Figure XVI, Figure XVII
*   **Data:** $w_t$, $n_t$, $d_t$, $r_t$, Capital stock ($k_t$), Land rents ($s_t$)
*   **Equations:**
    *   $\alpha_t, \beta_t$ are pinned down by land and capital demand: 
        * $s_t = w_t + n_t + d_t - \log Z + \log \alpha_t - \log(1 - \alpha_t - \beta_t) + \lambda$ (15)
        * $\log(r_t + \delta) = w_t + n_t + d_t - k_t + \log \beta_t - \log(1 - \alpha_t - \beta_t) + \lambda$ (16)
    *   $a_t$ is extracted via labor demand: 
        * $w_t = \phi_t + \frac{1}{1-\beta_t}a_t - \frac{\alpha_t}{1-\beta_t}(d_t + n_t) - \frac{\beta_t}{1-\beta_t}\log(r_t + \delta)$ (13)
    *   Converted to Malmquist productivity index ($m_t$) to account for structural change: 
        * $\hat{m}_t = \hat{a}_t + \hat{\alpha}_t \log Z + \hat{\beta}_t \bar{k}_t - (\hat{\alpha}_t + \hat{\beta}_t)(\bar{d}_t + \bar{n}_t + \lambda)$ (18)
    *   $m_t = \tilde{m}_t + \epsilon_{2t}$ (19)
    *   $\tilde{m}_t = \mu + \tilde{m}_{t-1} + \epsilon_{1t}$ (20)
    *   Population dynamics follow (9) and (10) as above.
*   **Plots/Estimates:** 
    *   **Table IV:** Estimates $\mu$.
    *   **Table V:** Estimates population income elasticity $\gamma$.
    *   **Figure I, Figure X, Figure XIII:** Plots the permanent component $\tilde{m}_t$ ($\tilde{a}_t$).
    *   **Figure XI:** Plots extracted structural parameters $\alpha_t, \beta_t$.
    *   **Figure XVI:** Plots $n_t$ simulated iteratively forward using (9) with shocks set to zero.
    *   **Figure XVII:** Plots $n_t$ estimated from the state-space model incorporating shock processes (10) and (11).
*   **Assumptions:** Independence is assumed between $\epsilon_1, \epsilon_2$ and between $\xi_1, \xi_2$. Factor share simplex ($\alpha_t, \beta_t, 1-\alpha_t-\beta_t$) is assumed to follow a Dirichlet prior distribution to discipline structural change after 1760. Input data assumed measured with independent error processes ($\iota_t$).

#### **4. Steady-State Analytics (Section V)**
*   **Used for:** Figure XIV, Figure XV
*   **Data:** $w_t$, $d_t$ (as well as posterior parameters from Section III.B)
*   **Equations:**
    *   $\bar{w} = \frac{\mu}{\alpha \gamma} + \text{constant}$ (21)
*   **Plots/Estimates:** 
    *   **Figure XIV:** Plots the theoretical $\bar{w}$ mapping across different values of $\alpha$ and $\mu$.
    *   **Figure XV:** Plots the ratio of theoretical steady-state wage $\bar{w}$ derived via (21) against the actual data $w_t$.

#### **5. Pure Data / No Structural Model Applied**
*   **Used for:** Table II, Table III, Figure II, Figure III, Figure IV, Figure VIII, Figure IX, Figure XII.
*   **Methodology:** These display raw historical input data, simple transformations (scatter plots), or statistical priors (Table III). No structural equations or error processes are applied.


# 2

Here is the glossary formatted as a Markdown table optimized for Quarto. `<br>` tags are used to introduce linebreaks within cells, keeping the columns compact and preventing the table from stretching beyond standard page widths.

| Category | Symbol | Definition / Description |
| :--- | :--- | :--- |
| **Observed Data & State Variables** | $w_t$ | Log of real wages |
| | $l_t$ | Log of total labor supply |
| | $n_t$ | Log of the population |
| | $d_t$ | Log of days worked per worker per year |
| | $k_t$ | Log of the capital stock |
| | $s_t$ | Log of the rental price of land |
| | $r_t$ | Rental rate for capital <br>*(Note: kept as a rate, appears in equations as $\log(r_t + \delta)$)* |
| | $Z$ | Fixed quantity of land <br>*(Appears in equations as $\log Z$)* |
| **Productivity Measures** | $a_t$ | Log of Total Factor Productivity (TFP) |
| | $\tilde{a}_t$ | Permanent (random-walk) component of TFP |
| | $m_t$ | Log of the Malmquist productivity index <br>*(Accounts for structural change when $\alpha_t, \beta_t$ vary)* |
| | $\tilde{m}_t$ | Permanent component of the Malmquist productivity index |
| | $\bar{w}$ | Theoretical steady-state real wage <br>*(Derived from the Malthusian model)* |
| | $\hat{x}_t$ | Difference/growth from the previous period <br>*(i.e., $x_t - x_{t-1}$)* |
| | $\bar{x}_t$ | Average of the current and previous period <br>*(i.e., $\frac{x_{t-1} + x_t}{2}$)* |
| **Structural Parameters** | $\alpha, \alpha_t$ | Elasticity of output with respect to land <br>*(Represents slope of labor demand in the simple model)* |
| | $\beta, \beta_t$ | Elasticity of output with respect to capital <br>*(Note: $1 - \alpha - \beta$ equals labor elasticity)* |
| | $\delta$ | Rate of depreciation of capital |
| | $\lambda$ | Log of the labor scaling constant $\Lambda$ <br>*(Maps population and days worked into total labor force)* |
| | $\mu$ | Average growth rate of productivity <br>*(Drift parameter in the random walk process)* |
| | $\gamma$ | Elasticity of population growth to real income <br>*(Represents the "Malthusian population force")* |
| | $\phi, \phi_t, \tilde{\phi}$ | Constant terms aggregating structural parameters, <br>fixed land ($Z$), and the labor scaling constant ($\lambda$) |
| | $\omega$ | Constant drift term in the population growth equation |
| **Shocks & Error Processes** | $\epsilon_{1t}$ | Permanent productivity shock <br>*(Innovation to the random walk of $\tilde{a}_t$ or $\tilde{m}_t$)* |
| | $\epsilon_{2t}$ | Transitory productivity shock <br>*(Captures weather variations, short-term noise, etc.)* |
| | $\xi_t$ | Total exogenous shock to population growth |
| | $\xi_{1t}$ | "Plague" shock <br>*(Rare, large negative shock modeled via mixture distribution)* |
| | $\xi_{2t}$ | Normal/transitory exogenous population shock |
| | $\sigma_{\epsilon_1}^2, \sigma_{\epsilon_2}^2, \sigma_{\xi_2}^2$ | Variances of their respective independent normal distributions |
| | $\iota_t$ | Measurement errors mapping true unobserved variables <br>to noisy observed data *(e.g., $\iota_t^d$ for days, $\iota_t^r$ for rates)* |

-----------------


Here is the summary of the robustness checks conducted by the authors, formatted as a table. `<br>` tags are used for linebreaks to ensure the table renders well.

| Testing for what | Test contents | If main result stays, what to expect | Table / Figure Number | Results |
| :--- | :--- | :--- | :--- | :--- |
| **Sensitivity to real wage data** | Substituted the baseline (Clark 2010 unskilled builders) series with:<br>1. Clark (2010) farm laborers<br>2. Clark (2010) craftsmen<br>3. Allen (2007) post-1770 wages<br>4. A noisy composite of the three Clark series<br>5. Humphries & Weisdorf (2019) annual income | The onset of sustained productivity growth should remain around 1600, and the overall trajectory of productivity over the centuries should not drastically change. | Online Appendix Figure A.5 | Yields similar results to the baseline productivity series, though with some minor divergence early in the sample period. |
| **Sensitivity to early population data** | Replaced the Clark (2007b) pre-1540 population trend data with Broadberry et al. (2015) population estimates. <br>*(Missing decades were treated as unobserved variables).* | Long-term productivity trends and the timing of the transition to growth should not depend heavily on the specific early demographic dataset used. | Online Appendix Figure A.6 | The evolution of productivity in this scenario is very similar to the baseline model. |
| **Sensitivity to break dates** | Instead of treating the pre-Industrial Revolution break date probabilistically (integrating over different possible dates), the model is conditioned on the break occurring at specific fixed dates between 1550 and 1760. | Fixing the break date to various years around the estimated 1600 mark should yield a permanent productivity component shape closely mirroring the baseline. | Online Appendix Figure A.7 | The alternative results are very similar to the baseline. |
| **Sensitivity to Bayesian priors** | 1. Changed the prior on the variance of permanent productivity shocks ($\sigma_{\epsilon_1}$) to $I\Gamma(3, 0.005)$ to match other shocks.<br>2. Changed the prior on early population level ($\psi$) to a much wider distribution $\mathcal{N}(10.86, 10^2)$. | The posterior estimates of productivity should not be highly sensitive to these statistical parameter choices (i.e., the data should dominate the priors). | Online Appendix Figure A.8 | In both cases, the resulting productivity series are very similar to the main results. |
| **Assumption of constant days worked** | Relaxed the assumption that labor supply is strictly proportional to the population by incorporating Humphries and Weisdorf's (2019) estimates of variable days worked per year. | The timing of the 1600 break should remain. However, the exact rate of productivity growth might shift to offset variations in the total hours of labor supplied. | Table V, <br>Figure XIII | Conclusion regarding the 1600 onset remains. Productivity growth estimates after 1600 are somewhat higher (3% per decade for 1600–1800; 6% for 1810–1870) to compensate for the labor supply associated with increased working days. |
| **Identification strategy for labor demand slope ($\alpha$)** | Instead of identifying the labor demand slope purely from the exogenous population shock of the Black Death, a diffuse prior is set for $\alpha, \beta$ and identified structurally using Bayesian updating on the entire sample. | The structurally estimated slope and the resulting productivity trajectory should align closely with the Black Death-identified baseline. | Figure XIII | Results are very similar to the baseline case. |
| **Assumption of constant structural parameters ($\alpha, \beta$)** | Compared a model where land/capital elasticities ($\alpha, \beta$) remain constant to the baseline model where the importance of land ($\alpha$) falls after 1760 due to steam power/coal. | The 1600 break should remain visible. If land's importance isn't allowed to fall, the model will be forced to attribute all post-1800 real wage resilience to raw productivity growth instead of structural change. | Table IV, <br>Figure X | The 1600 break holds. Post-1800 growth is massive under constant $\alpha, \beta$ (16% per decade) but drops to a modest 5% in the baseline because the baseline successfully explains explosive growth via structural change (falling $\alpha$). |

# 3 table

## This is too wide

* Growth = Industrial Revolution began in 1600's

    | period | growth |
    |---|:---:|
    | <span style="display:block; text-align:right;">&#45; 1600</span> | 0% |
    | <span style="display:block; text-align:center;">1600 &#45; 1810</span> | 2% |
    | <span style="display:block; text-align:left;">1810 &#45;</span> | 5% |
\\
    * Not after the Glorious Revolution, as argued in the literature
    * Predates 100 years from the Glorious Revolution

## This works

* Growth = Industrial Revolution began in 1600's

    <table style="margin: 10px auto; width: auto !important; border-collapse: collapse; line-height: 1.2;">
      <thead>
        <tr>
          <th style="text-align: center; padding: 4px 20px; border-bottom: 1px solid currentColor;">period</th>
          <th style="text-align: center; padding: 4px 20px; border-bottom: 1px solid currentColor;">growth</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td style="text-align: right; padding: 2px 20px;">&#45; 1600</td>
          <td style="text-align: center; padding: 2px 20px;">0%</td>
        </tr>
        <tr>
          <td style="text-align: center; padding: 2px 20px;">1600 &#45; 1810</td>
          <td style="text-align: center; padding: 2px 20px;">2%</td>
        </tr>
        <tr>
          <td style="text-align: left; padding: 2px 20px;">1810 &#45;</td>
          <td style="text-align: center; padding: 2px 20px;">5%</td>
        </tr>
      </tbody>
    </table>

    * Not after the Glorious Revolution, as argued in the literature
    * Predates 100 years from the Glorious Revolution
* A new series of TFP (1250-) is computed by combining existing data, a labour demand function, and Black Death as an exogenous population shock


# 4 Equations 

Here are all the equations updated with `\tag{#}` and `\label{eq:#}`. 

*(**Quarto Pro-Tip:** While standard LaTeX `\label{eq:1}` works inside the math block, Quarto's native cross-referencing usually prefers appending `{#eq-1}` to the outside of the math block like this: `$$ math $$ {#eq-1}`. I have provided the standard `\label{}` you requested, but keep the `{#eq-}` syntax in mind if your cross-references (`@eq-1`) fail to render!)*

## Section II: A Simple Estimate of Productivity Growth
  
$$
W_t = (1 - \alpha)A_t \left( \frac{Z}{L_t} \right)^\alpha
$$

$$
w_t = \phi + a_t - \alpha l_t \tag{1} \label{eq:1}
$$

$$
\phi = \log(1 - \alpha) + \alpha \log Z
$$

$$
n_t = \psi + \tilde{n}_t + \iota_t^n
$$

$$
\iota_t^n \sim t_{\nu_n}(0, \sigma_n^2)
$$

$$
\tilde{a}_t = \mu + \tilde{a}_{t-1} + \epsilon_{1t} \tag{2} \label{eq:2}
$$


## Section III.A: A Model of the Preindustrial Economy
  
$$
Y_t = F_t(Z, K_t, L_t) = A_t Z^\alpha K_t^\beta L_t^{1-\alpha-\beta}
$$

$$
W_t = (1 - \alpha - \beta) A_t Z^\alpha K_t^\beta L_t^{-\alpha-\beta}
$$

$$
w_t = \tilde{\phi} + a_t + \beta k_t - (\alpha + \beta)l_t \tag{3} \label{eq:3}
$$

$$
\tilde{\phi} = \log(1 - \alpha - \beta) + \alpha \log Z
$$

$$
r_t + \delta = \beta A_t Z^\alpha K_t^{\beta-1} L_t^{1-\alpha-\beta} \tag{4} \label{eq:4}
$$

$$
w_t = \tilde{\phi}' + \frac{1}{1-\beta} a_t - \frac{\alpha}{1-\beta} l_t - \frac{\beta}{1-\beta} \log(r_t + \delta) \tag{5} \label{eq:5}
$$

$$
\tilde{\phi}' = \frac{\beta}{1-\beta} \log \beta + \log(1 - \alpha - \beta) + \frac{\alpha}{1-\beta} \log Z
$$

$$
a_t = \tilde{a}_t + \epsilon_{2t} \tag{6} \label{eq:6}
$$

$$
\epsilon_{2t} \sim \mathcal{N}(0, \sigma_{\epsilon_2}^2)
$$

$$
\tilde{a}_t = \mu + \tilde{a}_{t-1} + \epsilon_{1t} \tag{7} \label{eq:7}
$$

$$
\epsilon_{1t} \sim \mathcal{N}(0, \sigma_{\epsilon_1}^2)
$$

$$
L_t = \Lambda D_t N_t
$$

$$
w_t = \phi + \frac{1}{1-\beta} a_t - \frac{\alpha}{1-\beta} (d_t + n_t) - \frac{\beta}{1-\beta} \log(r_t + \delta) \tag{8} \label{eq:8}
$$

$$
\phi = \tilde{\phi}' - \frac{\alpha}{1-\beta}\lambda \quad \text{with} \quad \lambda = \log \Lambda
$$

$$
\frac{N_t}{N_{t-1}} = \Omega (W_{t-1} D_{t-1})^\gamma \Xi_t
$$

$$
n_t - n_{t-1} = \omega + \gamma(w_{t-1} + d_{t-1}) + \xi_t \tag{9} \label{eq:9}
$$

$$
\xi_t = \xi_{1t} + \xi_{2t} \tag{10} \label{eq:10}
$$

$$
\exp(\xi_{1t}) \sim 
\begin{cases} 
\beta(\beta_1, \beta_2), & \text{with probability } \pi \\ 
1, & \text{with probability } 1 - \pi 
\end{cases} \tag{11} \label{eq:11}
$$

$$
\xi_{2t} \sim \mathcal{N}(0, \sigma_{\xi_2}^2)
$$


## Section III.B: A Model of the Early Industrial Economy
  
$$
Y_t = F_t(Z, K_t, L_t) = A_t Z^{\alpha_t} K_t^{\beta_t} L_t^{1-\alpha_t-\beta_t} \tag{12} \label{eq:12}
$$

$$
w_t = \phi_t + \frac{1}{1-\beta_t} a_t - \frac{\alpha_t}{1-\beta_t} (d_t + n_t) - \frac{\beta_t}{1-\beta_t} \log(r_t + \delta) \tag{13} \label{eq:13}
$$

$$
\phi_t = \frac{\beta_t}{1-\beta_t} \log \beta_t + \log(1 - \alpha_t - \beta_t) + \frac{\alpha_t}{1-\beta_t} \log Z - (\alpha_t + \beta_t)\lambda
$$

$$
S_t = \alpha_t A_t Z^{\alpha_t-1} K_t^{\beta_t} L_t^{1-\alpha_t-\beta_t} \tag{14} \label{eq:14}
$$

$$
s_t = w_t + n_t + d_t - \log Z + \log \alpha_t - \log(1 - \alpha_t - \beta_t) + \lambda \tag{15} \label{eq:15}
$$

$$
\log(r_t + \delta) = w_t + n_t + d_t - k_t + \log \beta_t - \log(1 - \alpha_t - \beta_t) + \lambda \tag{16} \label{eq:16}
$$

$$
D_t(X_{t+1}, Y_{t+1}) = \frac{F_{t+1}(X_{t+1})}{F_t(X_{t+1})}
$$

$$
D_{t+1}(X_t, Y_t) = \frac{F_t(X_t)}{F_{t+1}(X_t)}
$$

$$
\frac{M_t}{M_{t-1}} = \sqrt{ \frac{F_t(Z, K_t, L_t)F_t(Z, K_{t-1}, L_{t-1})}{F_{t-1}(Z, K_t, L_t)F_{t-1}(Z, K_{t-1}, L_{t-1})} }, \quad M_0 = 1 \tag{17} \label{eq:17}
$$

$$
\hat{m}_t = \hat{a}_t + \hat{\alpha}_t \log Z + \hat{\beta}_t \bar{k}_t - (\hat{\alpha}_t + \hat{\beta}_t)(\bar{d}_t + \bar{n}_t + \lambda) \tag{18} \label{eq:18}
$$

$$
\hat{x}_t = x_t - x_{t-1} \quad \text{and} \quad \bar{x}_t = \frac{x_{t-1} + x_t}{2}
$$

$$
m_t = \tilde{m}_t + \epsilon_{2t} \tag{19} \label{eq:19}
$$

$$
\tilde{m}_t = \mu + \tilde{m}_{t-1} + \epsilon_{1t} \tag{20} \label{eq:20}
$$


## Section III.D & III.E: Measurement Equations, Errors, and Priors
  
$$
r_t = \tilde{r}_{it} + \iota_{it}^r \quad \text{where} \quad \iota_{it}^r \sim t_{\nu_{ir}}(0, \tilde{\sigma}_{ir}^2)
$$

$$
r_t \sim \mathcal{N}_{(0,.2)}(r_{t-1}, 0.01^2)
$$

$$
s_t = \tilde{s}_t + \iota_t^s \quad \text{where} \quad \iota_t^s \sim t_{\nu_s}(0, \tilde{\sigma}_s^2)
$$

$$
k_t = \tilde{k}_t + \iota_t^k \quad \text{where} \quad \iota_t^k \sim t_{\nu_k}(0, \tilde{\sigma}_k^2)
$$

$$
\alpha = \tilde{\alpha}(1-\beta)
$$

$$
\mu_{\xi_1} = \frac{\beta_1}{\beta_1 + \beta_2} \quad \text{and} \quad \nu_{\xi_1} = \beta_1 + \beta_2
$$

$$
w_t = \phi^w + \tilde{w}_t \quad \text{where} \quad \phi^w \sim \mathcal{N}(0, 100^2)
$$

$$
\phi^s \sim \mathcal{N}(0, 100^2)
$$

$$
\phi^k \sim \mathcal{N}(0, 100^2)
$$


## Section IV: Productivity Estimates / Days Worked
  
$$
d_t = \tilde{d}_t + \iota_t^d \quad \text{where} \quad \iota_t^d \sim t_{\nu_d}(0, \tilde{\sigma}_d^2)
$$

$$
d_t = d_{t-1} + \eta_t \quad \text{where} \quad \eta_t \sim \mathcal{N}(0, \sigma_d^2)
$$


## Section V: Liberating the Economy from the Iron Law of Wages
  
$$
\bar{w} = \frac{\mu}{\alpha\gamma} + \text{constant} \tag{21} \label{eq:21}
$$

$$
n_{t+1} = \left( 1 - \frac{\gamma\alpha}{1-\beta} \right) n_t + \text{constant} \tag{22} \label{eq:22}
$$

$$
\text{Half-life} = \frac{\log 0.5}{\log \left( 1 - \frac{\alpha\gamma}{1-\beta} \right)}
$$


## Footnote 13: Malmquist Index Unit Invariance Example
  
$$
\ddot{L}_t \equiv \psi L_t
$$

$$
Y_t = A_t Z^{\alpha_t} K_t^{\beta_t} \ddot{L}_t^{1-\alpha_t-\beta_t} = \frac{A_t}{\psi^{1-\alpha_t-\beta_t}} Z^{\alpha_t} K_t^{\beta_t} L_t^{1-\alpha_t-\beta_t}
$$

# 5 refs

@article{AcemogluRestrepo2018,
  author = {Acemoglu, Daron and Restrepo, Pascual},
  title = {The Race between Man and Machine: Implications of Technology for Growth, Factor Shares, and Employment},
  journal = {American Economic Review},
  volume = {108},
  year = {2018},
  pages = {1488--1542},
  doi = {10.1257/aer.20160696}
}

@incollection{AcemogluRestrepo2019a,
  author = {Acemoglu, Daron and Restrepo, Pascual},
  title = {Artificial Intelligence, Automation, and Work},
  booktitle = {The Economics of Artificial Intelligence: An Agenda},
  editor = {Agrawal, Ajay and Gans, Joshua and Goldfarb, Avi},
  publisher = {University of Chicago Press},
  address = {Chicago},
  year = {2019},
  pages = {197--236}
}

@article{AcemogluRestrepo2019b,
  author = {Acemoglu, Daron and Restrepo, Pascual},
  title = {Automation and New Tasks: How Technology Displaces and Reinstates Labor},
  journal = {Journal of Economic Perspectives},
  volume = {33},
  year = {2019},
  pages = {3--30},
  doi = {10.1257/jep.33.2.3}
}

@article{AcemogluJohnsonRobinson2005,
  author = {Acemoglu, Daron and Johnson, Simon and Robinson, James},
  title = {The Rise of Europe: Atlantic Trade, Institutional Change, and Economic Growth},
  journal = {American Economic Review},
  volume = {95},
  year = {2005},
  pages = {546--579},
  doi = {10.1257/0002828054201305}
}

@book{Allen1992,
  author = {Allen, Robert C.},
  title = {Enclosure and the Yeoman},
  publisher = {Oxford University Press},
  address = {Oxford},
  year = {1992}
}

@article{Allen2009b,
  author = {Allen, Robert C.},
  title = {Engels’ Pause: Technical Change, Capital Accumulation, and Inequality in the British Industrial Revolution},
  journal = {Explorations in Economic History},
  volume = {46},
  year = {2009},
  pages = {418--435},
  doi = {10.1016/j.eeh.2009.04.004}
}

@techreport{Allen2005,
  author = {Allen, Robert C.},
  title = {English and Welsh Agriculture, 1300--1850: Output, Inputs, and Income},
  type = {Working Paper},
  institution = {Oxford University},
  address = {Oxford},
  year = {2005}
}

@techreport{Allen2007,
  author = {Allen, Robert C.},
  title = {Pessimism Preserved: Real Wages in the British Industrial Revolution},
  type = {Department of Economics Working Paper no. 314},
  institution = {Oxford University},
  address = {Oxford},
  year = {2007}
}

@book{Allen2009a,
  author = {Allen, Robert C.},
  title = {The British Industrial Revolution in Global Perspective},
  publisher = {Cambridge University Press},
  address = {Cambridge},
  year = {2009}
}

@article{BaileyChambers1993,
  author = {Bailey, R. E. and Chambers, M. J.},
  title = {Long-Term Demographic Interactions in Pre-census England},
  journal = {Journal of the Royal Statistical Society, Series A},
  volume = {156},
  year = {1993},
  pages = {339--362},
  doi = {10.2307/2983062}
}

@book{BarroSalaIMartin2004,
  author = {Barro, Robert J. and Sala-i-Martin, Xavier},
  title = {Economic Growth},
  edition = {2nd},
  publisher = {MIT Press},
  address = {Cambridge, MA},
  year = {2004}
}

@article{BeckerBarro1988,
  author = {Becker, Gary S. and Barro, Robert J.},
  title = {A Reformulation of the Economic Theory of Fertility},
  journal = {Quarterly Journal of Economics},
  volume = {103},
  year = {1988},
  pages = {1--25},
  doi = {10.2307/1882640}
}

@article{BeckerLewis1973,
  author = {Becker, Gary S. and Lewis, H. Gregg},
  title = {On the Interaction between the Quantity and Quality of Children},
  journal = {Journal of Political Economy},
  volume = {81},
  year = {1973},
  pages = {S279--S288},
  doi = {10.1086/260166}
}

@techreport{Betancourt2018,
  author = {Betancourt, Michael},
  title = {A Conceptual Introduction to Hamiltonian Monte Carlo},
  type = {arXiv working paper 1701.02434v2},
  year = {2018},
  url = {https://doi.org/10.48550/arXiv.1701.02434}
}

@article{Blanchard1978,
  author = {Blanchard, Ian},
  title = {Labor Productivity and Work Psychology in the English Mining Industry, 1400--1600},
  journal = {Economic History Review},
  volume = {31},
  year = {1978},
  pages = {1--24},
  doi = {10.2307/2595798}
}

@article{BogartRichardson2011,
  author = {Bogart, Dan and Richardson, Gary},
  title = {Property Rights and Parliament in Industrializing Britain},
  journal = {Journal of Law and Economics},
  volume = {54},
  year = {2011},
  pages = {241--274},
  doi = {10.1086/652901}
}

@techreport{BoppartEtAl2023,
  author = {Boppart, Timo and Kiernan, Patrick and Krusell, Per and Malmberg, Hannes},
  title = {The Macroeconomics of Intensive Agriculture},
  type = {NBER Working Paper no. 31101},
  year = {2023},
  doi = {10.3386/w31101}
}

@misc{BouscasseNakamuraSteinsson2024,
  author = {Bouscasse, Paul and Nakamura, Emi and Steinsson, J\'{o}n},
  title = {Replication Data for: 'When Did Growth Begin? New Estimates of Productivity Growth in England from 1250 to 1870'},
  howpublished = {Harvard Dataverse},
  year = {2024},
  doi = {10.7910/DVN/5EXFLU}
}

@book{BroadberryEtAl2015,
  author = {Broadberry, Stephen and Campbell, Bruce M. S. and Klein, Alexander and Overton, Mark and van Leeuwen, Bas},
  title = {British Economic Growth, 1270--1870},
  publisher = {Cambridge University Press},
  address = {Cambridge},
  year = {2015}
}

@article{CavesChristensenDiewert1982,
  author = {Caves, Douglas W. and Christensen, Laurits R. and Diewert, W. Erwin},
  title = {The Economic Theory of Index Numbers and the Measurement of Input, Output, and Productivity},
  journal = {Econometrica},
  volume = {50},
  year = {1982},
  pages = {1393--1414},
  doi = {10.2307/1913388}
}

@article{ChaneyHornbeck2016,
  author = {Chaney, Eric and Hornbeck, Richard},
  title = {Economic Dynamics in the Malthusian Era: Evidence from the 1609 Spanish Expulsion of the Moriscos},
  journal = {Economic Journal},
  volume = {126},
  year = {2016},
  pages = {1404--1440},
  doi = {10.1111/ecoj.12309}
}

@article{Clark2002,
  author = {Clark, Gregory},
  title = {Land Rental Values and the Agrarian Economy: England and Wales, 1500--1914},
  journal = {European Review of Economic History},
  volume = {6},
  year = {2002},
  pages = {281--308},
  doi = {10.1017/S136149160200014X}
}

@article{Clark2016,
  author = {Clark, Gregory},
  title = {Microbes and Markets: Was the Black Death an Economic Revolution?},
  journal = {Journal of Demographic Economics},
  volume = {82},
  year = {2016},
  pages = {139--165},
  doi = {10.1017/dem.2016.6}
}

@article{Clark2005,
  author = {Clark, Gregory},
  title = {The Condition of the Working Class in England, 1209--2004},
  journal = {Journal of Political Economy},
  volume = {113},
  year = {2005},
  pages = {1307--1340},
  doi = {10.1086/498123}
}

@article{Clark2007b,
  author = {Clark, Gregory},
  title = {The Long March of History: Farm Wages, Population, and Economic Growth, England 1209--1869},
  journal = {Economic History Review},
  volume = {60},
  year = {2007},
  pages = {97--135},
  doi = {10.1111/j.1468-0289.2006.00358.x}
}

@article{Clark2010,
  author = {Clark, Gregory},
  title = {The Macroeconomic Aggregates for England 1209--1869},
  journal = {Research in Economic History},
  volume = {27},
  year = {2010},
  pages = {51--140},
  doi = {10.1108/S0363-3268(2010)0000027004}
}

@book{Clark2007a,
  author = {Clark, Gregory},
  title = {A Farewell to Alms},
  publisher = {Princeton University Press},
  address = {Princeton, NJ},
  year = {2007}
}

@misc{ClarkLevin2011,
  author = {Clark, Gregory and Levin, Patricua A.},
  title = {How Different Was the Industrial Revolution? The Revolution in Printing, 1350--1835},
  howpublished = {Unpublished paper},
  year = {2011}
}

@article{ClarkVanDerWerf1998,
  author = {Clark, Gregory and Van Der Werf, Ysbrand},
  title = {Work in Progress? The Industrious Revolution},
  journal = {Journal of Economic History},
  volume = {58},
  year = {1998},
  pages = {830--843},
  doi = {10.1017/S0022050700021197}
}

@article{Crafts1983,
  author = {Crafts, Nicholas F. R.},
  title = {British Economic Growth, 1700--1831: A Review of the Evidence},
  journal = {Economic History Review},
  volume = {36},
  year = {1983},
  pages = {177--199},
  doi = {10.2307/2595919}
}

@book{Crafts1985,
  author = {Crafts, Nicholas F. R.},
  title = {British Economic Growth during the Industrial Revolution},
  publisher = {Clarendon Press},
  address = {Oxford},
  year = {1985}
}

@article{CraftsHarley1992,
  author = {Crafts, Nicholas F. R. and Harley, C. Knick},
  title = {Output Growth and the British Industrial Revolution: A Restatement of the Crafts-Harley View},
  journal = {Economic History Review},
  volume = {45},
  year = {1992},
  pages = {703--730},
  doi = {10.2307/2597415}
}

@article{CraftsMills2009,
  author = {Crafts, Nicholas and Mills, Terence C.},
  title = {From Malthus to Solow: How Did the Malthusian Economy Really Evolve?},
  journal = {Journal of Macroeconomics},
  volume = {31},
  year = {2009},
  pages = {68--93},
  doi = {10.1016/j.jmacro.2007.08.007}
}

@book{Cressy1980,
  author = {Cressy, David},
  title = {Literacy and the Social Order},
  publisher = {Cambridge University Press},
  address = {Cambridge},
  year = {1980},
  doi = {10.1017/CBO9780511560484}
}

@article{DeMoorVanZanden2010,
  author = {De Moor, Tine and van Zanden, Jan Luiten},
  title = {Girl Power: The European Marriage Pattern and Labor Markets in the North Sea Region in the Late Medieval and Early Modern Period},
  journal = {Economic History Review},
  volume = {63},
  year = {2010},
  pages = {1--33},
  doi = {10.1111/j.1468-0289.2009.00483.x}
}

@article{DeVries1994,
  author = {De Vries, Jan},
  title = {The Industrial Revolution and the Industrious Revolution},
  journal = {Journal of Economic History},
  volume = {54},
  year = {1994},
  pages = {249--270},
  doi = {10.1017/S0022050700014467}
}

@book{DeVries2008,
  author = {De Vries, Jan},
  title = {The Industrious Revolution: Consumer Behavior and the Household Economy, 1650 to the Present},
  publisher = {Cambridge University Press},
  address = {Cambridge},
  year = {2008}
}

@incollection{DiewertNakamura2007,
  author = {Diewert, W. Erwin and Nakamura, Alice O.},
  title = {The Measurement of Productivity for Nations},
  booktitle = {Handbook of Econometrics, Volume 6, Part A},
  editor = {Heckman, James J. and Leamer, Edward E.},
  publisher = {Elsevier},
  address = {Amsterdam},
  year = {2007},
  pages = {4501--4586},
  doi = {10.1016/S1573-4412(07)06066-7}
}

@article{Dittmar2011,
  author = {Dittmar, Jeremiah E.},
  title = {Information Technology and Economic Change: The Impact of the Printing Press},
  journal = {Quarterly Journal of Economics},
  volume = {126},
  year = {2011},
  pages = {1133--1172},
  doi = {10.1093/qje/qjr035}
}

@book{Engels1845,
  author = {Engels, Frederick},
  title = {The Condition of the Working Class in England},
  publisher = {Oxford University Press},
  address = {Oxford},
  year = {1845}
}

@article{FareEtAl1994,
  author = {F\"{a}re, Rolf and Grosskopf, Shawna and Norris, Mary and Zhang, Zhongyang},
  title = {Productivity Growth, Technical Progress, and Efficiency Change in Industrialized Countries},
  journal = {American Economic Review},
  volume = {84},
  year = {1994},
  pages = {66--83}
}

@incollection{Feinstein1988,
  author = {Feinstein, Charles H.},
  title = {National Statistics, 1760--1920},
  booktitle = {Studies in Capital Formation in the United Kingdom, 1750--1920},
  editor = {Feinstein, Charles H. and Pollard, S.},
  publisher = {Clarendon Press},
  address = {Oxford},
  year = {1988},
  pages = {259--471}
}

@article{Feinstein1998,
  author = {Feinstein, Charles H.},
  title = {Pessimism Perpetuated: Real Wages and the Standard of Living in Britain during and after the Industrial Revolution},
  journal = {Journal of Economic History},
  volume = {58},
  year = {1998},
  pages = {625--658},
  doi = {10.1017/S0022050700021100}
}

@article{GalorWeil2000,
  author = {Galor, Oded and Weil, David N.},
  title = {Population, Technology, and Growth: From Malthusian Stagnation to the Demographic Transition and Beyond},
  journal = {American Economic Review},
  volume = {90},
  year = {2000},
  pages = {806--828},
  doi = {10.1257/aer.90.4.806}
}

@book{GelmanEtAl2013,
  author = {Gelman, Andrew and Carlin, John B. and Stern, Hal S. and Dunson, David B. and Vehtari, Aki and Rubin, Donald B.},
  title = {Bayesian Data Analysis},
  edition = {3rd},
  publisher = {CRC Press},
  address = {Boca Raton, FL},
  year = {2013}
}

@article{Goldstone2002,
  author = {Goldstone, Jack A.},
  title = {Efflorescences and Economic Growth in World History: Rethinking the 'Rise of the West' and the Industrial Revolution},
  journal = {Journal of World History},
  volume = {13},
  year = {2002},
  pages = {323--389},
  doi = {10.1353/jwh.2002.0034}
}

@article{HansenPrescott2002,
  author = {Hansen, Gary D. and Prescott, Edward C.},
  title = {Malthus to Solow},
  journal = {American Economic Review},
  volume = {92},
  year = {2002},
  pages = {1205--1217},
  doi = {10.1257/00028280260344731}
}

@techreport{HansenOhanianOzturk2020,
  author = {Hansen, Gary D. and Ohanian, Lee E. and Ozturk, Fatih},
  title = {Dynamic General Equilibrium Modelling of Long and Short-Run Historical Events},
  type = {NBER Working Paper no. 28090},
  year = {2020},
  doi = {10.3386/w28090}
}

@article{Harley1982,
  author = {Harley, C. Knick},
  title = {British Industrialization Before 1841: Evidence of Slower Growth During the Industrial Revolution},
  journal = {Journal of Economic History},
  volume = {42},
  year = {1982},
  pages = {267--289},
  doi = {10.1017/S0022050700027431}
}

@article{HeldringRobinsonVollmer2021,
  author = {Heldring, Leander and Robinson, James A. and Vollmer, Sebastian},
  title = {The Long-Run Impact of the Dissolution of the English Monasteries},
  journal = {Quarterly Journal of Economics},
  volume = {136},
  year = {2021},
  pages = {2093--2145},
  doi = {10.1093/qje/qjab030}
}

@book{Hill1940,
  author = {Hill, Christopher},
  title = {The English Revolution 1640},
  publisher = {Lawrence and Wishart},
  address = {London},
  year = {1940}
}

@book{Hill1961,
  author = {Hill, Christopher},
  title = {The Century of Revolution},
  publisher = {Van Nostrand Reinhold},
  address = {New York},
  year = {1961}
}

@article{Houston1982,
  author = {Houston, R. A.},
  title = {The Development of Literacy: Northern England, 1640--1750},
  journal = {Economic History Review},
  volume = {35},
  year = {1982},
  pages = {199--216},
  doi = {10.1111/j.1468-0289.1982.tb01193.x}
}

@article{Hsieh2002,
  author = {Hsieh, Chang-Tai},
  title = {What Explains the Industrial Revolution in East Asia? Evidence from the Factor Markets},
  journal = {American Economic Review},
  volume = {92},
  year = {2002},
  pages = {502--526},
  doi = {10.1257/00028280260136372}
}

@article{HumphriesWeisdorf2019,
  author = {Humphries, Jane and Weisdorf, Jacob},
  title = {Unreal Wages? Real Income and Economic Growth in England, 1260--1850},
  journal = {Economic Journal},
  volume = {129},
  year = {2019},
  pages = {2867--2887},
  doi = {10.1093/ej/uez017}
}

@article{Jones2001,
  author = {Jones, Charles I.},
  title = {Was an Industrial Revolution Inevitable? Economic Growth Over the Very Long Run},
  journal = {B.E. Journal in Macroeconomics},
  volume = {1},
  year = {2001},
  pages = {1--43},
  doi = {10.2202/1534-6013.1028}
}

@article{Kremer1993,
  author = {Kremer, Michael},
  title = {Population Growth and Technological Change: One Million B.C. to 1990},
  journal = {Quarterly Journal of Economics},
  volume = {108},
  year = {1993},
  pages = {681--716},
  doi = {10.2307/2118405}
}

@article{LeeAnderson2002,
  author = {Lee, Ronald and Anderson, Michael},
  title = {Malthus in State Space: Macro Economic-Demographic Relationships in English History, 1540--1870},
  journal = {Journal of Population Economics},
  volume = {15},
  year = {2002},
  pages = {195--220},
  doi = {10.1007/s001480100091}
}

@article{Malmquist1953,
  author = {Malmquist, Sten},
  title = {Index Numbers and Indifference Surfaces},
  journal = {Trabajos de estad\'{i}stica},
  volume = {4},
  year = {1953},
  pages = {209--242},
  doi = {10.1007/BF03006863}
}

@book{Malthus1798,
  author = {Malthus, Thomas R.},
  title = {An Essay on the Principle of Population},
  publisher = {J. Johnson in St. Paul's Church-yard},
  address = {London},
  year = {1798}
}

@book{MarxEngels1848,
  author = {Marx, Karl and Engels, Friedrich},
  title = {The Communist Manifesto},
  publisher = {Pluto Press},
  address = {London},
  year = {2008},
  note = {Original 1848, English translation by Samuel Moore in cooperation with Friedrich Engels 1888}
}

@book{Marx1867,
  author = {Marx, Karl},
  title = {Capital. A Critique of Political Economy, volume 1},
  publisher = {Charles H. Kerr \& Company},
  address = {Chicago},
  year = {1932},
  note = {Original German 1867. English translation by Samuel Moore and Edward Aveling}
}

@book{McCloskey2006,
  author = {McCloskey, Deirdre},
  title = {The Bourgeois Virtues: Ethics for an Age of Commerce},
  publisher = {University of Chicago Press},
  address = {Chicago},
  year = {2006},
  doi = {10.7208/chicago/9780226556673.001.0001}
}

@book{McCloskey2010,
  author = {McCloskey, Deirdre},
  title = {Bourgeois Dignity: Why Economics Can't Explain the Modern World},
  publisher = {University of Chicago Press},
  address = {Chicago},
  year = {2010}
}

@book{McCloskey2016,
  author = {McCloskey, Deirdre},
  title = {Bourgeois Equality: How Ideas, Not Capital or Institutions, Enriched the World},
  publisher = {University of Chicago Press},
  address = {Chicago},
  year = {2016}
}

@book{Mokyr2009,
  author = {Mokyr, Joel},
  title = {The Enlightened Economy: The Economic History of Britain, 1700--1850},
  publisher = {Yale University Press},
  address = {New Haven, CT},
  year = {2009}
}

@book{Mokyr2016,
  author = {Mokyr, Joel},
  title = {A Culture of Growth: The Origins of the Modern Economy},
  publisher = {Princeton University Press},
  address = {Princeton, NJ},
  year = {2016}
}

@article{NorthWeingast1989,
  author = {North, Douglass C. and Weingast, Barry R.},
  title = {Constitutions and Commitment: The Evolution of Institutions Governing Public Choice in Seventeenth Century England},
  journal = {Journal of Economic History},
  volume = {49},
  year = {1989},
  pages = {803--832},
  doi = {10.1017/S0022050700009451}
}

@article{Persson2008,
  author = {Persson, Karl Gunnar},
  title = {The Malthus Delusion},
  journal = {European Review of Economic History},
  volume = {12},
  year = {2008},
  pages = {165--173},
  doi = {10.1017/S1361491608002219}
}

@book{RosenbergBirdzell1986,
  author = {Rosenberg, Nathan and Birdzell, L. E.},
  title = {How the West Grew Rich: The Economic Transformation of the Industrial World},
  publisher = {Basic Books},
  address = {New York},
  year = {1986}
}

@article{Solow1957,
  author = {Solow, Robert M.},
  title = {Technical Change and the Aggregate Production Function},
  journal = {Review of Economics and Statistics},
  volume = {39},
  year = {1957},
  pages = {312--330},
  doi = {10.2307/1926047}
}

@manual{StanDevelopmentTeam2017,
  author = {{Stan Development Team}},
  title = {Stan Modeling Language Users Guide and Reference Manual, version 2.17.0},
  year = {2017},
  url = {https://mc-stan.org}
}

@book{Tawney1926,
  author = {Tawney, R. H.},
  title = {Religion and the Rise of Capitalism},
  publisher = {Routledge},
  address = {New York},
  year = {1926}
}

@article{VoigtlanderVoth2013,
  author = {Voigtl\"{a}nder, Nico and Voth, Hans-Joachim},
  title = {How the West 'Invented' Fertility Restriction},
  journal = {American Economic Review},
  volume = {103},
  year = {2013},
  pages = {2227--2264},
  doi = {10.1257/aer.103.6.2227}
}

@book{Voth2000,
  author = {Voth, Hans-Joachim},
  title = {Time and Work in England, 1750--1830},
  publisher = {Oxford University Press},
  address = {Oxford},
  year = {2000}
}

@article{Voth2001,
  author = {Voth, Hans-Joachim},
  title = {The Longest Years: New Estimates of Labor Input in England, 1760--1830},
  journal = {Journal of Economic History},
  volume = {61},
  year = {2001},
  pages = {1065--1082},
  doi = {10.1017/S0022050701042085}
}

@article{WallisColsonChilosi2018,
  author = {Wallis, Patrick and Colson, Justin and Chilosi, David},
  title = {Structural Change and Economic Growth in the British Economy before the Industrial Revolution, 1500--1800},
  journal = {Journal of Economic History},
  volume = {78},
  year = {2018},
  pages = {862--903},
  doi = {10.1017/S0022050718000396}
}

@article{Weber1904,
  author = {Weber, Max},
  title = {The Protestant Ethic and the 'Spirit' of Capitalism},
  journal = {Archiv f\"{u}r Sozialwissenschaft und Sozialpolitik},
  volume = {20},
  year = {1904},
  pages = {1--54},
  note = {English translation by Peter Baehr and Gordon C. Wells, (New York: Penguin Books, 2002)}
}

@article{Weber1905,
  author = {Weber, Max},
  title = {Protestant Ethic and the Spirit of Capitalism: The Work Ethic of Ascetic Protestantism},
  journal = {Archiv f\"{u}r Sozialwissenschaft und Sozialpolitik},
  volume = {21},
  year = {1905},
  pages = {1--110},
  note = {English translation by Peter Baehr and Gordon C. Wells, (New York: Penguin Books, 2002)}
}

@book{WrigleySchofield1981,
  author = {Wrigley, E. A. and Schofield, R. S.},
  title = {The Population History of England 1541--1871},
  publisher = {Cambridge University Press},
  address = {Cambridge},
  year = {1981}
}

@book{WrigleyEtAl1997,
  author = {Wrigley, E. A. and Davies, R. S. and Oeppen, J. E. and Schofield, R. S.},
  title = {English Population History from Family Reconstruction, 1580--1837},
  publisher = {Cambridge University Press},
  address = {Cambridge},
  year = {1997}
}

@book{Wrigley2010,
  author = {Wrigley, E. Anthony},
  title = {Energy and the English Industrial Revolution},
  publisher = {Cambridge University Press},
  address = {Cambridge},
  year = {2010}
}

# 6 asked to claude

read C:\seiro\docs\personal\Miscelleneous\testrepo\posts\BoucasseNakamuraSteinsson\BoucasseNakamuraSteinsson_WhenGrowth_QJE2025_app.pdf and extract all equations (with \tag and \label if needed) in latex math so I can paste in quarto doc

read C:\seiro\docs\personal\Miscelleneous\testrepo\posts\BoucasseNakamuraSteinsson\BoucasseNakamuraSteinsson_WhenGrowth_QJE2025.pdf
How are (8) and (9) used to estimate fixed alpha?

read C:\seiro\docs\personal\Miscelleneous\testrepo\posts\BoucasseNakamuraSteinsson\BoucasseNakamuraSteinsson_WhenGrowth_QJE2025.pdf, ClaudeRes1.txt, 
files in C:\seiro\docs\personal\Miscelleneous\testrepo\posts\BoucasseNakamuraSteinsson\dataverse_files\bns_replication\code 
use pdftools and Rscript to read pdf
I was inquiring how likelihood is formed for (8) and (9)
How does the error/noise come in to form a likelihood for (8)? Through a_{t} and (6) (7)?  

In C:\seiro\docs\personal\Miscelleneous\testrepo\posts\BoucasseNakamuraSteinsson\, there is a text excerpt file BoucasseNakamuraSteinsson_text.txt for BoucasseNakamuraSteinsson_WhenGrowth_QJE2025.pdf
read this, ClaudeRes1.txt, files in C:\seiro\docs\personal\Miscelleneous\testrepo\posts\BoucasseNakamuraSteinsson\dataverse_files\bns_replication\code 
I was inquiring how likelihood is formed for (8) and (9) 
How does the error/noise come in to form a likelihood for (8)? Through a_{t} and (6) (7)?  
and deleted your response accidentally
there is output file:///C:/seiro/docs/personal/Miscelleneous/testrepo/posts/BoucasseNakamuraSteinsson/BNS_likelihood.html
So (\mathcal L_{7}) is processed and pass atilde to (\mathcal L_{8}) in MCMC? 
Provide MCMC chain scheme and add to BNS_likelihood.html
a1 ~ p(a|x,y,z)
x1 ~ p(x|a,y,z)
y1 ~ p(y|a,x,z)
...


Any issues with statistical power? Give me sample size for each tables and figures.

	