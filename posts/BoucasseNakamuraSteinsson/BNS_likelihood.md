---
title: "BNS (2025): Likelihood Formation for Equations (8) and (9)"
author: "Notes"
date: "2026-06-02"
format:
  html:
    toc: true
    toc-depth: 3
    number-sections: false
    embed-resources: true
bibliography: bns_refs.bib
---

```{=html}
<style>
#gibbs-tbl-wrap table { table-layout: fixed; width: 100%; }
#gibbs-tbl-wrap table th:nth-child(1),
#gibbs-tbl-wrap table td:nth-child(1) { width: 22%; }
#gibbs-tbl-wrap table th:nth-child(2),
#gibbs-tbl-wrap table td:nth-child(2) { width: 50%; text-align: center; }
#gibbs-tbl-wrap table th:nth-child(3),
#gibbs-tbl-wrap table td:nth-child(3) { width: 28%; text-align: center; }
</style>
```

# Overview

Bouscasse, Nakamura, and Steinsson (2025, QJE) estimate a Malthusian model
of pre-industrial England via Bayesian HMC (Stan).  The observation
equations for wages (8) and population (9) are coupled through a
latent productivity state $\tilde{a}_t$.  This note derives the
conditional likelihood contributed by each equation and shows how
measurement noise enters.

---

# Model equations

## Productivity process — equations (6) and (7)

Total log productivity decomposes into a permanent and a transitory
component:

$$
a_t = \tilde{a}_t + \varepsilon_{2t}, \qquad \varepsilon_{2t} \sim
\mathcal{N}(0,\sigma_2^2) \tag{6}
$$

The permanent component follows a random walk with drift:

$$
\tilde{a}_t = \mu + \tilde{a}_{t-1} + \varepsilon_{1t}, \qquad
\varepsilon_{1t} \sim \mathcal{N}(0,\sigma_1^2) \tag{7}
$$

Both shocks are i.i.d. and mutually independent.
$\mu$ is the mean growth rate of productivity, which is allowed to
break at two dates (one fixed at 1810; one estimated between 1550 and 1800).

## Labor demand — equation (8)

With a Cobb-Douglas production function
$Y_t = A_t Z^{\alpha_t} K_t^{\beta_t} L_t^{1-\alpha_t-\beta_t}$,
substituting the capital demand equation (4) into the labor demand
equation (3) to eliminate the unobserved capital stock yields:

$$
w_t = \phi +
\frac{1}{1-\beta}\,a_t -
\frac{\alpha}{1-\beta}(d_t + n_t) -
\frac{\beta}{1-\beta}\log(r_t + \delta) \tag{8}
$$

where $w_t$ = log real wage, $n_t$ = log population,
$d_t$ = log days worked, $r_t$ = rental rate on capital, $\delta$ =
depreciation rate.

## Population supply — equation (9)

Following Malthus, population growth responds to lagged real income:

$$
n_t - n_{t-1} = \omega + \gamma(w_{t-1} + d_{t-1}) + \xi_t \tag{9}
$$

The composite shock $\xi_t = \xi_{1t} + \xi_{2t}$ (eq. 10) has two
independent components:

* **Plague shock** (eq. 11): $\exp(\xi_{1t}) \sim \operatorname{Beta}(\beta_1,\beta_2)$
  with probability $\pi$; $\exp(\xi_{1t}) = 1$ (i.e. $\xi_{1t}=0$) with
  probability $1-\pi$.
* **Symmetric shock**: $\xi_{2t} \sim \mathcal{N}(0,\sigma_\xi^2)$.

---

# Likelihood formation

## Equation (8): wage measurement equation

### How noise enters

Substitute (6) into (8):

$$
w_t = \underbrace{\phi + \frac{1}{1-\beta}\,\tilde{a}_t
      - \frac{\alpha}{1-\beta}(d_t+n_t)
      - \frac{\beta}{1-\beta}\log(r_t+\delta)}_{\displaystyle\mu_{w,t}(\tilde{a}_t)}
    \;+\; \frac{\varepsilon_{2t}}{1-\beta}
$$

The transitory productivity shock $\varepsilon_{2t}$ from equation (6) is
the *sole* noise source.  It is scaled by $1/(1-\beta)$ because $a_t$
enters (8) with coefficient $1/(1-\beta)$.  The permanent component
$\tilde{a}_t$ enters only through the *mean*; it carries no noise of its
own at this stage.

### Conditional likelihood

$$
\boxed{
w_t \;\Big|\; \tilde{a}_t,\,n_t,\,d_t,\,r_t,\,\alpha,\beta,\phi
\;\sim\;
\mathcal{N}\!\left(\mu_{w,t}(\tilde{a}_t),\;
\left[\frac{\sigma_2}{1-\beta}\right]^{\!2}\right)
}
\tag{$\mathcal{L}_8$}
$$

where

$$
\mu_{w,t}(\tilde{a}_t) \;\equiv\;
\phi + \frac{\tilde{a}_t}{1-\beta}
      - \frac{\alpha}{1-\beta}(d_t+n_t)
      - \frac{\beta}{1-\beta}\log(r_t+\delta)
$$

### Log-likelihood contribution

$$
\log p(w_t \mid \cdot) =
-\frac{1}{2}\log(2\pi)
-\log\!\frac{\sigma_2}{1-\beta}
-\frac{\bigl(w_t - \mu_{w,t}\bigr)^2}
      {2\,\bigl(\sigma_2/(1-\beta)\bigr)^2}
$$

The residual $w_t - \mu_{w,t}$ recovers $\varepsilon_{2t}/(1-\beta)$.
Stan stores this residual as `e2 = (1-betat).*(w - phi[1] - lbdm)`,
where `lbdm` $= \mu_{w,t} - \phi$.

### Role of equation (7)

Equation (7) is the **state transition** for $\tilde{a}_t$.  It
contributes a separate likelihood factor (state equation):

$$
\tilde{a}_t \;\Big|\; \tilde{a}_{t-1},\mu,\sigma_1
\;\sim\; \mathcal{N}(\mu + \tilde{a}_{t-1},\;\sigma_1^2)
\tag{$\mathcal{L}_7$}
$$

In Stan: `mlq[t] ~ normal(mu_a[i] + mlq[t-1], se1[i])`.

This is **not** observation noise in the wage equation.
It is the uncertainty in the *level* of $\tilde{a}_t$ itself — how
much the permanent component shifts each period due to $\varepsilon_{1t}$.
Because the full path $\{\tilde{a}_t\}$ is sampled as free parameters
(`dmlq[t]` in Stan), HMC jointly tightens the state path against both
the state-equation likelihood ($\mathcal{L}_7$) and the wage
measurement-equation likelihood ($\mathcal{L}_8$).

### Summary: two-noise structure for the wage

| Noise | Symbol | Where it enters | Variance in wage likelihood |
|-------|--------|-----------------|-----------------------------|
| Permanent productivity shock | $\varepsilon_{1t}$ | State eq. (7): shapes the trajectory of $\tilde{a}_t$ | Not directly — only through $\tilde{a}_t$ via $\mathcal{L}_7$ |
| Transitory productivity shock | $\varepsilon_{2t}$ | Measurement eq. (6)→(8): residual of observed wage | $\sigma_2^2/(1-\beta)^2$ |

---

## Equation (9): population supply equation

### How noise enters

Define the deterministic part of equation (9):

$$
\mu_{n,t} \;\equiv\; \omega + \gamma(w_{t-1} + d_{t-1}) + n_{t-1}
$$

Then $n_t = \mu_{n,t} + \xi_{1t} + \xi_{2t}$.  The noise $\xi_{2t}
\sim \mathcal{N}(0,\sigma_\xi^2)$ makes $n_t$ normal *conditional on*
$\xi_{1t}$.  The plague shock $\xi_{1t}$ shifts the mean; its occurrence
is uncertain.

### Conditional likelihood — mixture form

The plague indicator is not observed.  Integrating over it gives a
two-component mixture:

$$
\boxed{
p(n_t \mid w_{t-1},d_{t-1},n_{t-1},\xi_{1t},\pi)
= \pi\cdot\mathcal{N}\bigl(n_t;\;\mu_{n,t}+\xi_{1t},\;\sigma_\xi^2\bigr)
+ (1-\pi)\cdot\mathcal{N}\bigl(n_t;\;\mu_{n,t},\;\sigma_\xi^2\bigr)
}
\tag{$\mathcal{L}_9$}
$$

where $\xi_{1t} = \log(\mathrm{XI1}_t)$ and
$\mathrm{XI1}_t \sim \mathrm{Beta}(\beta_1,\beta_2)$.

### Plague shock likelihood

The plague intensity $\mathrm{XI1}_t$ (fraction of population surviving)
is itself a sampled parameter with its own likelihood:

$$
\mathrm{XI1}_t \sim \mathrm{Beta}(\beta_1,\beta_2), \qquad
\xi_{1t} = \log(\mathrm{XI1}_t) \leq 0
$$

```{=html}
<blockquote style="border-left:3px solid #d0d7de; margin:0.8em 0; padding:6px 14px; color:#444; font-size:0.95em;">
<p style="margin:0 0 4px 0;"><strong>Beta distribution.</strong>
\(\mathrm{Beta}(\beta_1,\beta_2)\) has density
\(f(x) \propto x^{\beta_1-1}(1-x)^{\beta_2-1}\) on \((0,1)\),
with mean \(\beta_1/(\beta_1+\beta_2)\).
\(\beta_1\) pulls mass toward 1; \(\beta_2\) pulls mass toward 0;
the sum \(\beta_1+\beta_2\) controls concentration.</p>
<p style="margin:4px 0 0 0;">Here \(\mathrm{XI1}_t\) is the surviving fraction, so \(\beta_2\) large
relative to \(\beta_1\) concentrates mass near 0 — most plague draws are severe.
The posterior calibrates both from data.</p>
</blockquote>
```

### Log-likelihood contribution

$$
\log p(n_t,\,\mathrm{XI1}_t \mid \cdot)
= \underbrace{\log\mathrm{Beta}(\mathrm{XI1}_t;\beta_1,\beta_2)}_{\text{plague intensity prior}}
+ \underbrace{\log\!\left[
    \pi\,\phi_{\sigma_\xi}\!\left(n_t - \mu_{n,t} - \xi_{1t}\right)
  + (1-\pi)\,\phi_{\sigma_\xi}\!\left(n_t - \mu_{n,t}\right)
  \right]}_{\text{mixture population likelihood}}
$$

where $\phi_{\sigma}(\cdot)$ is the $\mathcal{N}(0,\sigma^2)$ density.

In Stan this is implemented via `log_mix`:

```stan
target += log_mix(p[j],
            normal_lpdf(n[t] | mu_n_t + xi1[t], sx2),   // plague
            normal_lpdf(n[t] | mu_n_t,          sx2));  // no plague
target += beta_lpdf(XI1[t] | betap[1], betap[2]);
```

---

# Full joint likelihood (per period $t$)

Combining all contributions, the full per-period log-likelihood is:

$$
\log L_t = \underbrace{\log p(\tilde{a}_t \mid \tilde{a}_{t-1})}_{\mathcal{L}_7:\;\text{state eq.}}
+ \underbrace{\log p(w_t \mid \tilde{a}_t,\ldots)}_{\mathcal{L}_8:\;\text{wage eq.}}
+ \underbrace{\log p(\mathrm{XI1}_t \mid \beta_1,\beta_2)}_{\text{plague intensity}}
+ \underbrace{\log p(n_t \mid w_{t-1},n_{t-1},\xi_{1t})}_{\mathcal{L}_9:\;\text{pop. eq.}}
$$

The full sample likelihood is marginalized over the unknown first
break date $\tau$ by a log-sum-exp over all candidate break dates
(each weighted by the Dirichlet probability $\pi_j$):

$$
\log L = \log\sum_{j}\pi_j \exp\!\left(\sum_t \log L_t^{(j)}\right)
$$

where $\log L_t^{(j)}$ uses the regime-specific drift $\mu^{(i)}$ and
variances $\sigma_1^{(i)},\sigma_2^{(i)}$ associated with break-date
candidate $j$.

---

# State-space interpretation

The structure of (6), (7), (8) is a non-linear state-space model:

```
State equation  (7):   ã_t  =  μ + ã_{t-1}  +  ε_{1t}       ε_{1t} ~ N(0, σ₁²)
Obs. equation (6)+(8): w_t  =  μ_{w,t}(ã_t)  +  ε_{2t}/(1−β) ε_{2t} ~ N(0, σ₂²)
```

A standard Kalman filter would marginalize over $\{\tilde{a}_t\}$
analytically.  BNS instead sample the full path as free parameters
(`dmlq[t]`, the period-by-period increments $\tilde{a}_t - \tilde{a}_{t-1}$)
using HMC.  This avoids linearity requirements and allows for
the non-Gaussian population mixture in (9) to be handled in the same
sampler.

---

# MCMC chain scheme

## Does $\mathcal{L}_7$ "pass" $\tilde{a}_t$ to $\mathcal{L}_8$?

**No.** BNS use HMC (Stan), not Gibbs sampling.  In each leapfrog step,
Stan evaluates the gradient of the full joint log-posterior with respect
to *all* parameters simultaneously.  The gradient with respect to
$\tilde{a}_t$ is:

$$
\nabla_{\tilde{a}_t}\,\log p(\text{all}) \;=\;
\underbrace{\nabla_{\tilde{a}_t}\log\mathcal{L}_7}_{\text{from state eq.}}
\;+\;
\underbrace{\nabla_{\tilde{a}_t}\log\mathcal{L}_8}_{\text{from wage eq.}}
$$

Both likelihood terms constrain $\tilde{a}_t$ at once.  There is no
sequential "process $\mathcal{L}_7$, then hand $\tilde{a}_t$ to
$\mathcal{L}_8$."

In Gibbs terms, the full conditional for $\tilde{a}_t$ given everything
else is:

$$
p(\tilde{a}_t \mid \text{rest})
\;\propto\;
\underbrace{p(\tilde{a}_t \mid \tilde{a}_{t-1},\mu,\sigma_1)}_{\mathcal{L}_7}
\cdot
\underbrace{p(w_t \mid \tilde{a}_t,\alpha,\beta,\phi,n_t,d_t,r_t)}_{\mathcal{L}_8}
$$

HMC samples from this joint full conditional in one step; the two
factors are inseparable.

## Block Gibbs representation (conceptual)

The table below shows the conditional dependency structure as if one ran
block Gibbs.  In practice, HMC updates all blocks simultaneously; the
blocks show which likelihood factors constrain each group of parameters.

::: {#gibbs-tbl-wrap}
| Block | Parameters (Stan names) | Full conditional driven by |
|-------|--------------------------|---------------------------|
| **A** Productivity path | `dmlq[t]` $\to$ `mlq[t]` $= \tilde{a}_t$, for all $t$ | $\mathcal{L}_7 \times \mathcal{L}_8$ |
| **B** Growth regime | `mu_a[i]` $= \mu^{(i)}$, `se1[i]` $= \sigma_1^{(i)}$ | $\mathcal{L}_7$ |
| **C** Obs. noise | `se2[i]` $= \sigma_2^{(i)}$ | $\mathcal{L}_8$ |
| **D** Factor shares | `beta0` $= \beta$ (IV) or `alpha_smplx` $= (\alpha,\beta,1{-}\alpha{-}\beta)$ (structural) | $\mathcal{L}_8$ |
| **E** Wage const. | `phi[1]` $= \phi$ | $\mathcal{L}_8$ |
| **F** Malthusian | `gamma` $= \gamma$, `omega` $= \omega$, `sx2` $= \sigma_\xi$ | $\mathcal{L}_9$ |
| **G** Plague intensity | `XI1[t]` $= \exp(\xi_{1t})$ (plague years) | Beta prior $\times\ \mathcal{L}_9$ |
| **H** Plague hyper | `betap[1,2]` $= (\beta_1,\beta_2)$, `p_plague` $= \pi$ | Beta/Dirichlet hyperprior |
| **I** Break date | `piv[j]` $= p_j$ (Dirichlet weights over break candidates) | log-sum-exp over $j$ |
:::

## Gibbs-style chain

```{=html}
<div style="border:1px solid #d0d7de; border-radius:6px; margin:1.5em 0; overflow:hidden;">
  <div style="background:#24292f; color:#e6edf3; padding:8px 18px;
              font-family:'SFMono-Regular',Consolas,monospace; font-size:0.87em;
              font-weight:600; letter-spacing:0.02em;">
    Algorithm 1 (conceptual) &mdash; Block Gibbs for BNS MCMC, iteration k+1
  </div>
  <table style="border-collapse:collapse; width:100%;
                font-family:'SFMono-Regular',Consolas,monospace;
                font-size:0.83em; line-height:1.7; margin:0;">
  <colgroup>
    <col style="width:2.8em; background:#f6f8fa; border-right:1px solid #eaecef;">
    <col>
  </colgroup>
  <tbody>
  <tr style="border-bottom:1px solid #eaecef; background:#f6f8fa;">
    <td style="text-align:center; padding:5px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; font-size:0.85em; vertical-align:top;">In</td>
    <td style="padding:5px 18px; color:#555;">data (<b>w</b>, <b>n</b>, <b>d</b>, <b>r</b>); fixed <code>slope0</code> = &alpha;/(1&minus;&beta;) (IV case)</td>
  </tr>
  <tr>
    <td style="text-align:right; padding:5px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">1</td>
    <td style="padding:5px 18px;"><b>for</b> k = 1, 2, &hellip; <b>do</b></td>
  </tr>
  <tr style="background:#fff8e8; border-top:2px solid #eaecef;">
    <td style="text-align:right; padding:4px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">2</td>
    <td style="padding:4px 18px 4px 2.5em; font-weight:600;">
      <span style="float:right; color:#666; font-weight:normal; font-size:0.92em;">&larr; \(\mathcal{L}_7 \times \mathcal{L}_8\)</span>
      [A]&nbsp; Productivity path
    </td>
  </tr>
  <tr style="background:#fff8e8;">
    <td style="text-align:right; padding:2px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">3</td>
    <td style="padding:2px 18px 5px 5em;">
      <code>dmlq[t]</code><sup>k+1</sup> &sim;&nbsp; p( <code>dmlq[t]</code> |&nbsp; &mu;<sub>a</sub><sup>k</sup>, &sigma;<sub>1</sub><sup>k</sup>, &sigma;<sub>2</sub><sup>k</sup>, &beta;<sup>k</sup>, &phi;<sup>k</sup>, <b>w</b>, <b>n</b>, <b>d</b>, <b>r</b> ) &nbsp;<span style="color:#999; font-size:0.9em;">// for all t</span>
    </td>
  </tr>
  <tr style="background:#f6f8fa; border-top:2px solid #eaecef;">
    <td style="text-align:right; padding:4px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">4</td>
    <td style="padding:4px 18px 4px 2.5em; font-weight:600;">
      <span style="float:right; color:#666; font-weight:normal; font-size:0.92em;">&larr; \(\mathcal{L}_7\)</span>
      [B]&nbsp; Growth regime
    </td>
  </tr>
  <tr>
    <td style="text-align:right; padding:2px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">5</td>
    <td style="padding:2px 18px 2px 5em;"><code>mu_a[i]</code><sup>k+1</sup> &sim;&nbsp; p( <code>mu_a</code> |&nbsp; <code>dmlq</code><sup>k+1</sup>, <code>se1</code><sup>k</sup>, <code>piv</code><sup>k</sup> )</td>
  </tr>
  <tr>
    <td style="text-align:right; padding:2px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">6</td>
    <td style="padding:2px 18px 5px 5em;"><code>se1[i]</code><sup>k+1</sup> &sim;&nbsp; p( <code>se1</code> |&nbsp; <code>dmlq</code><sup>k+1</sup>, <code>mu_a</code><sup>k+1</sup>, <code>piv</code><sup>k</sup> )</td>
  </tr>
  <tr style="background:#f6f8fa; border-top:2px solid #eaecef;">
    <td style="text-align:right; padding:4px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">7</td>
    <td style="padding:4px 18px 4px 2.5em; font-weight:600;">
      <span style="float:right; color:#666; font-weight:normal; font-size:0.92em;">&larr; \(\mathcal{L}_8\)</span>
      [C]&nbsp; Observation noise
    </td>
  </tr>
  <tr>
    <td style="text-align:right; padding:2px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">8</td>
    <td style="padding:2px 18px 5px 5em;"><code>se2[i]</code><sup>k+1</sup> &sim;&nbsp; p( <code>se2</code> |&nbsp; <code>dmlq</code><sup>k+1</sup>, &beta;<sup>k</sup>, &phi;<sup>k</sup>, <b>w</b>, <code>piv</code><sup>k</sup> )</td>
  </tr>
  <tr style="background:#f6f8fa; border-top:2px solid #eaecef;">
    <td style="text-align:right; padding:4px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">9</td>
    <td style="padding:4px 18px 4px 2.5em; font-weight:600;">
      <span style="float:right; color:#666; font-weight:normal; font-size:0.92em;">&larr; \(\mathcal{L}_8\)</span>
      [D]&nbsp; Factor shares
    </td>
  </tr>
  <tr>
    <td style="text-align:right; padding:2px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">10</td>
    <td style="padding:2px 18px 2px 5em;"><code>beta0</code><sup>k+1</sup> &sim;&nbsp; p( &beta; |&nbsp; <code>dmlq</code><sup>k+1</sup>, <code>se2</code><sup>k+1</sup>, &phi;<sup>k</sup>, <b>w</b>, <b>n</b>, <b>d</b>, <b>r</b> )</td>
  </tr>
  <tr>
    <td style="text-align:right; padding:2px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">11</td>
    <td style="padding:2px 18px 5px 5em; color:#555;">&alpha; = <code>slope0</code> &times; (1 &minus; &beta;) &nbsp;<span style="color:#999; font-size:0.9em;">// deterministic, IV case</span></td>
  </tr>
  <tr style="background:#f6f8fa; border-top:2px solid #eaecef;">
    <td style="text-align:right; padding:4px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">12</td>
    <td style="padding:4px 18px 4px 2.5em; font-weight:600;">
      <span style="float:right; color:#666; font-weight:normal; font-size:0.92em;">&larr; \(\mathcal{L}_8\)</span>
      [E]&nbsp; Wage normalization
    </td>
  </tr>
  <tr>
    <td style="text-align:right; padding:2px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">13</td>
    <td style="padding:2px 18px 5px 5em;"><code>phi</code><sup>k+1</sup> &sim;&nbsp; p( &phi; |&nbsp; <code>dmlq</code><sup>k+1</sup>, <code>beta0</code><sup>k+1</sup>, <code>se2</code><sup>k+1</sup>, <b>w</b> )</td>
  </tr>
  <tr style="background:#f6f8fa; border-top:2px solid #eaecef;">
    <td style="text-align:right; padding:4px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">14</td>
    <td style="padding:4px 18px 4px 2.5em; font-weight:600;">
      <span style="float:right; color:#666; font-weight:normal; font-size:0.92em;">&larr; \(\mathcal{L}_9\)</span>
      [F]&nbsp; Malthusian feedback
    </td>
  </tr>
  <tr>
    <td style="text-align:right; padding:2px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">15</td>
    <td style="padding:2px 18px 2px 5em;"><code>gamma</code><sup>k+1</sup> &sim;&nbsp; p( &gamma; |&nbsp; <b>w</b>, <b>n</b>, <b>d</b>, &omega;<sup>k</sup>, &sigma;<sub>&xi;</sub><sup>k</sup>, XI1<sup>k</sup>, <code>piv</code><sup>k</sup> )</td>
  </tr>
  <tr>
    <td style="text-align:right; padding:2px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">16</td>
    <td style="padding:2px 18px 2px 5em;"><code>omega</code><sup>k+1</sup> &sim;&nbsp; p( &omega; |&nbsp; <b>w</b>, <b>n</b>, <b>d</b>, &gamma;<sup>k+1</sup>, &sigma;<sub>&xi;</sub><sup>k</sup>, XI1<sup>k</sup>, <code>piv</code><sup>k</sup> )</td>
  </tr>
  <tr>
    <td style="text-align:right; padding:2px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">17</td>
    <td style="padding:2px 18px 5px 5em;"><code>sx2</code><sup>k+1</sup> &sim;&nbsp; p( &sigma;<sub>&xi;</sub> |&nbsp; <b>w</b>, <b>n</b>, <b>d</b>, &gamma;<sup>k+1</sup>, &omega;<sup>k+1</sup>, XI1<sup>k</sup>, <code>piv</code><sup>k</sup> )</td>
  </tr>
  <tr style="background:#f6f8fa; border-top:2px solid #eaecef;">
    <td style="text-align:right; padding:4px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">18</td>
    <td style="padding:4px 18px 4px 2.5em; font-weight:600;">
      <span style="float:right; color:#666; font-weight:normal; font-size:0.92em;">&larr; Beta &times; \(\mathcal{L}_9\)</span>
      [G]&nbsp; Plague intensity <span style="font-weight:normal; color:#888; font-size:0.9em;">(plague years only)</span>
    </td>
  </tr>
  <tr>
    <td style="text-align:right; padding:2px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">19</td>
    <td style="padding:2px 18px 5px 5em;"><code>XI1[t]</code><sup>k+1</sup> &sim;&nbsp; p( XI1 |&nbsp; <b>n</b>, &gamma;<sup>k+1</sup>, &omega;<sup>k+1</sup>, &sigma;<sub>&xi;</sub><sup>k+1</sup>, <code>betap</code><sup>k</sup>, &pi;<sup>k</sup> )</td>
  </tr>
  <tr style="background:#f6f8fa; border-top:2px solid #eaecef;">
    <td style="text-align:right; padding:4px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">20</td>
    <td style="padding:4px 18px 4px 2.5em; font-weight:600;">
      <span style="float:right; color:#666; font-weight:normal; font-size:0.92em;">&larr; hyperpriors</span>
      [H]&nbsp; Plague hyperparameters
    </td>
  </tr>
  <tr>
    <td style="text-align:right; padding:2px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">21</td>
    <td style="padding:2px 18px 2px 5em;"><code>betap</code><sup>k+1</sup> &sim;&nbsp; p( &beta;<sub>1</sub>, &beta;<sub>2</sub> |&nbsp; XI1<sup>k+1</sup> )</td>
  </tr>
  <tr>
    <td style="text-align:right; padding:2px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">22</td>
    <td style="padding:2px 18px 5px 5em;"><code>p_plague</code><sup>k+1</sup> &sim;&nbsp; p( &pi; |&nbsp; XI1<sup>k+1</sup>, <b>n</b> )</td>
  </tr>
  <tr style="background:#f6f8fa; border-top:2px solid #eaecef;">
    <td style="text-align:right; padding:4px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">23</td>
    <td style="padding:4px 18px 4px 2.5em; font-weight:600;">
      <span style="float:right; color:#666; font-weight:normal; font-size:0.92em;">&larr; log-sum-exp over j</span>
      [I]&nbsp; Break date weights
    </td>
  </tr>
  <tr>
    <td style="text-align:right; padding:2px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">24</td>
    <td style="padding:2px 18px 5px 5em;"><code>piv</code><sup>k+1</sup> &sim;&nbsp; p( piv |&nbsp; <code>dmlq</code><sup>k+1</sup>, <code>mu_a</code><sup>k+1</sup>, <code>se1</code><sup>k+1</sup>, <code>se2</code><sup>k+1</sup>, <b>w</b>, <b>n</b> )</td>
  </tr>
  <tr style="border-top:2px solid #eaecef;">
    <td style="text-align:right; padding:5px 8px; color:#999; border-right:1px solid #eaecef; user-select:none; vertical-align:top;">25</td>
    <td style="padding:5px 18px;"><b>end for</b></td>
  </tr>
  </tbody>
  </table>
  <div style="border-top:1px solid #eaecef; background:#f6f8fa; padding:6px 18px;
              font-family:'SFMono-Regular',Consolas,monospace; font-size:0.8em; color:#666;">
    BNS HMC updates all blocks simultaneously; the block structure shows conditional dependency only.
    Block&nbsp;[A] (yellow) is the central hub: <code>dmlq[t]</code> is constrained jointly by
    \(\mathcal{L}_7\) (state eq.) and \(\mathcal{L}_8\) (wage eq.).
  </div>
</div>
```

**Key point:** Block A is the central hub.  `dmlq[t]` is pulled toward
values consistent with *both* the random-walk prior on $\tilde{a}_t$
($\mathcal{L}_7$) and the observed wages ($\mathcal{L}_8$).  This is the
Bayesian smoothing: $\mathcal{L}_7$ acts as a prior on the state path;
$\mathcal{L}_8$ updates it with the wage signal.  All blocks are updated
in one HMC trajectory, not sequentially.

---

# What the 1600 onset rules out

Sustained productivity growth beginning around 1600 is inconsistent with
theories that locate the decisive cause of growth in later political events,
or that explain eighteenth-century wage stagnation by capital capturing all
technical gains.

* **Glorious Revolution (1688)** [@NorthWeingast1989].^[North and Weingast
argue that the post-GR power-sharing arrangement among Parliament, the Crown,
and the common law courts secured property rights and rule of law, laying the
foundation for growth. Ruled out as the *onset*: productivity already rose 34%
from 1600 to 1680—roughly a century before 1688.]

* **English Civil War (1642–1651) and Glorious Revolution as joint cause**
[@AcemogluJohnsonRobinson2005].^[Acemoglu, Johnson, and Robinson synthesize
the Marxist and institutionalist views: Atlantic trade enriched a merchant
class that then secured property rights through the Civil War and the Glorious
Revolution. Ruled out as the trigger: growth preceded the Civil War by ~40
years, and no acceleration is detected in the immediate aftermath of either
event (decadal TFP growth: 3.2% in 1600–1640, 4.2% in 1640–1680, 4.5% in
1680–1810).]

* **Post-Glorious Revolution property rights and enclosure reforms**
[@BogartRichardson2011].^[Bogart and Richardson stress the post-GR regime's
reorganization of property rights through enclosures, statutory authority
acts, and estate acts. Ruled out as the *onset*; the authors note these
reforms may have helped *sustain* growth already underway.]

* **Industrial Revolution (~1800) as the genesis of growth**.^[The traditional
view holds that growth began with industrialization around 1800. Ruled out:
BNS estimate 2% per decade TFP growth from 1600 to 1800, well before the IR.
The larger post-1810 acceleration (5% per decade) is attributed largely to
structural change—a falling land share in production—not faster productivity
growth.]

* **Capital capturing the gains from technical change as the explanation for
Engels' Pause** [@Allen2009b; @AcemogluRestrepo2019a].^[The standard view of
stagnant real wages in the late eighteenth century is that the fruits of
technical change accrued to capital rather than labor—an idea with modern
resonance in discussions of automation and AI. BNS instead attribute Engels'
Pause to rapid population growth exerting Malthusian downward pressure on the
marginal product of labor.]

---

# Surviving theories

The 1600 onset is consistent with—or directly corroborated by—theories centred
on developments in the late sixteenth and early seventeenth centuries.
Evidence strength follows the paper's own language.

## Corroborating (external data independently confirm the timing)

* Onset of structural transformation away from agriculture
  [@WallisColsonChilosi2018].^[Wallis, Colson, and Chilosi estimate
  that the share of workers in agriculture began a sustained fall around
  1600 after being stable in the sixteenth century, and that labour
  productivity in agriculture, industry, and services all started rising
  around 1600. The paper calls this alignment "lines up well."]

## Consistent (timing of historical events aligns with 1600)

* Dissolution of the English monasteries and land-market shock
  [@HeldringRobinsonVollmer2021].^[Henry VIII's confiscation of monastic
  lands (1530s–1540s) was a large shock to land ownership and the land
  market. England also became a destination for skilled Protestant
  immigrants fleeing persecution on the continent. The paper calls the
  Reformation "an obvious candidate."]

* Rise of the yeoman class and gradual expansion of property rights
  [@Allen1992].^[Allen argues that a 600-year process from the Norman
  Conquest culminated in the sixteenth century with the yeoman class
  holding a substantial proprietary interest in land, and hence an
  incentive to innovate. The paper notes this "lines up reasonably well"
  with the estimated onset.]

* Atlantic trade, colonisation, and London's urbanisation.^[The British
  East India Company was founded in 1600; the Virginia Company established
  its first permanent North American settlement in 1607. London's population
  exploded from 55,000 (1520) to 475,000 (1670), driven by rapid expansion
  of international trade in woollens, intercontinental commerce, and
  privateering. Timing coincides directly with the 1600 break.]

* Printing press and rising literacy [@Dittmar2011].^[Spread of
  movable-type printing after 1450 produced large literacy gains in England
  in the sixteenth and seventeenth centuries and a sharp fall in book
  prices. Dittmar finds that cities exposed to printing grew substantially
  faster than otherwise comparable cities. Timing is consistent with the
  1600 onset.]

* Marxist view: economic change propels political change
  [@Marx1867; @MarxEngels1848].^[Marx stressed the transition from
  feudalism to capitalism—expulsion of peasants through enclosure creating
  a proletariat available for wage labour, ultimately driving political
  revolution. The finding that growth preceded both the Civil War and the
  Glorious Revolution is consistent with economic transformation causing
  political change rather than the reverse. The paper says this "lends
  support" to the Marxist view.]

## Consistent but timing hard to pin down

* Culture of progress and bourgeois values [@Mokyr2009; @Mokyr2016;
  @McCloskey2006].^[Mokyr and McCloskey argue that the crucial change was
  the emergence of a science-based culture holding that human conditions
  can be improved through rational thought. The paper notes the timing
  "lines up reasonably well" but acknowledges it is "not straightforward
  to pinpoint precisely what these theories imply about the timing of the
  onset of growth."]

* Protestant ethic and Puritanism [@Weber1904; @Tawney1926].^[Weber and
  Tawney link the Protestant Reformation to attitudes favouring diligence,
  thrift, and commercial activity. The paper applies the same caveat as
  for culture-of-progress theories: timing is reasonably consistent but
  imprecise.]

## Complementary (explains the character of the Industrial Revolution, not its onset)

* High-wage, cheap-coal theory of the Industrial Revolution
  [@Allen2009a].^[Allen argues that the IR took the particular form it
  did—labour-saving textile machinery, steam engines—because growth in the
  seventeenth century had already pushed English wages high relative to
  coal prices, making it uniquely profitable to invent such technologies.
  The paper notes this "helps explain how growth was sustained and the
  particular direction it took" but does not point to it as the genesis
  of growth.]

---

# Statistical power: summary by data used

Data are decadal averages throughout. All posteriors are reported as mean ±
SD with 95% credible interval [2.5%, 97.5%].

## Wages + population only (1250–1860, T = 61)

★ Table I, Fig. V, Fig. VI, Fig. VII

* Table I ★ — posterior of $\mu$ (3 regimes).
  $\hat\mu_{a,2}$ (post-1600) = 0.04, SD 0.02, CI [0.02, 0.10]:
  upper bound is five times the lower bound.
* Fig. V ★ — break-date probability, window 1550–1800 (26 candidate decades).
  59% probability the break falls before 1640; 73% before 1680.
  The "1600" label is a simplification of a posterior that spans ~50 years.
* Fig. VI — permanent productivity $\tilde{a}_t$, simple model. 90% CI bands
  widen substantially before 1400 where population data are thinner.
* Fig. VII — productivity vs real wages (display).

## Wages + population + capital + interest rates
## (wages/pop: T = 61; capital/rates: 1760–1860, T = 10)

Table IV (constant α,β row), Fig. X (constant α,β line)

Land rents **not used** — confirmed: `include_Z = 0` excludes the land demand
likelihood from the Stan model entirely.
α identified from Black Death IV: **2 data points** (1340, 1360).
Slope uncertainty is absorbed into the prior, not sampled.

* Table IV constant α,β — $\hat\mu_{a,2}$ = 0.03, SD 0.01, CI [0.01, 0.05].
  Tighter than Table I because capital absorbs some residual variation.
  Capital and rates identified from 10 post-1760 decades only.
* Fig. X constant α,β line — productivity time series under this restriction.

## Wages + population + capital + interest rates + land rents
## (wages/pop: T = 61; capital/rates/rents: 1760–1860, T = 10)

★ Fig. I, Table IV (baseline row), Fig. X (baseline line), Fig. XI

Land rents enter **only here** (`include_Z = 1`): equations (15)–(16) identify
the time path of $\alpha_t$, $\beta_t$ from 10 post-1760 observations.

* Fig. I ★ — main productivity series (introduction). Baseline specification.
* Table IV baseline ★ — $\hat\mu_{a,2}$ = 0.02, SD 0.01, CI [0.01, 0.04];
  $\hat\mu_{a,3}$ = 0.05, SD 0.01, CI [0.03, 0.08].
  Tighter than constant α,β because the falling land share absorbs post-1760
  variation that would otherwise inflate the productivity residual.
* Fig. X baseline line ★ — permanent productivity, baseline. Main visual result.
* Fig. XI — $\alpha_t$, $\beta_t$ evolution from 1760. 90% CI is wide throughout;
  prior (Dirichlet, $c_s = 3$) contributes substantially with only 10 observations.

## Wages + population + variable days worked (Humphries & Weisdorf 2019,
## 1260–1840, T ≈ 59)

Table V (variable days row), Fig. XIII

* Table V ★ — $\hat\gamma$: baseline 0.03, SD 0.05, CI [−0.06, 0.12] —
  **includes zero**; variable-days 0.09, SD 0.02, CI [0.05, 0.14].
  The Malthusian feedback mechanism is imprecisely estimated in the baseline.
  Only the variable-days specification yields a credible interval excluding zero.
* Fig. XIII — productivity with variable days. Estimates somewhat higher
  post-1600 (3% vs 2%/decade) to offset the added labour input.

## Display / descriptive / prior specification (no estimation issues)

Fig. II (wages vs population scatter), Fig. III (real wages),
Fig. IV (population), Fig. VIII (capital stock, from 1760),
Fig. IX (land rents and capital, from 1760), Fig. XII (days worked),
Table II (energy consumption), Table III (prior distributions)

## Steady-state analytics (posterior draws from baseline)

Fig. XIV, Fig. XV — theoretical steady-state wage $\bar{w} = \mu/(\alpha\gamma)$.
Precision inherited from the $\gamma$ posterior: wide when constant days
(baseline), tighter with variable days.

---

**Land rents in the fixed α,β model:** not used.
Stan switch `include_Z = 0` removes equations (15)–(16) from the likelihood.
Capital and interest rates are included regardless; land rents are exclusive
to the time-varying baseline (`include_Z = 1`).
