# R로 시계열 분석하기

이 자료는 **응용 시계열 분석 및 예측**에 대한 강의 노트 모음으로, 통계 프로그래밍 언어 **R**을 사용합니다. 이 강의 노트의 상당수는 Y. R. Gel과 C. Cutler가 캐나다 워털루 대학교의 STAT-443 예측 과정을 위해 작성한 원본 노트를 기반으로 하며, 미국 메릴랜드 대학교의 MEES-713 환경 통계 2 과정을 위해 V. Lyubchich가 각색하고 확장했습니다.

각 강의는 학습 목표와 필수 독서 자료를 나열하는 것으로 시작하며, 본문에는 추가 참고 자료가 포함되어 있습니다. 이 노트는 방법론을 소개하고 몇 가지 예시를 제공하지만, 독서 자료만큼 상세하지는 않습니다. 이 노트는 교과서를 대체하지 않습니다.

이 강의를 듣는 학생들은 **R 프로그래밍**과 다음 통계 개념 및 방법론에 익숙할 것으로 예상됩니다. 즉, **확률 분포, 표본 추론 및 가설 검정, 상관 분석, 회귀 분석** (단순 및 다중 선형 회귀, 혼합 효과 모델, 일반화 선형 모델, 일반화 가법 모델 포함) 등입니다.

---

# 향후 작업

  - 인과 관계를 별도의 강의 10으로 만들고, 대마초 예시를 포함한 차분-차분법(diff-in-diff) 추가.
  - 강의 2 또는 ARIMA에 예시 커버리지 계산 추가, 궁극적으로 L02의 일부 자료를 모델 평가 및 예측에 대한 별도 강의로 이동. forecast::accuracy(). caret::postResample(obs = y\_test, pred = y\_dnn) 과적합. B\&D Ch. 9.
    모든 예측 추론은 변수 간의 관계 및 동학이 미래에도 동일할 것이라는 가정에 기반한다는 점을 기억하십시오.
  - 패널 데이터 분석에 대한 강의 추가.
  - 웨이블릿 확장, 음향 데이터 예시 추가.
  - 부록 또는 변화점 분석에 대한 강의.
  - 어업 또는 생태학을 위한 분류 예시가 포함된 GLM 또는 기타 일반화 모델.
  - 국소 정상성(local stationarity), 워핑(warping), 시간 모티프(time motifs), 시계열의 그래프 표현.
  - G.N.과의 NOAA 프로젝트에서: "환경 통계 2: 시계열에서 다른 유형의 희귀 이벤트 식별 (부록?), 시계열 교차 검증 (L 12?), GAMLSS (TSREG2 강의 12 - 완료; 강의 3 - 완료)".

-----

# 규칙 및 형식 예시

## 철자

a.k.a.
changepoint (변화점)
dataset (데이터셋)
heteroskedasticity (이분산성)
homoskedasticity (등분산성)
hyperparameter (하이퍼파라미터)
nondeterministic (비결정론적)
nonlinear (비선형)
nonnegative (음이 아닌)
nonparametric (비모수적)
nonstationarity (비정상성)
non-existent (존재하지 않는)
non-monotonic (비단조)
non-normal (비정규)
non-overlapping (겹치지 않는)
non-seasonal (비계절성)
scatterplot (산점도)
vs. (대비)

-----

## 형식

$p$-값
$\\mathrm{WN}(0,\\sigma^2)$
$N(0,1)$
$X\_t \\sim$ I(2)

\\boldsymbol
$\\dots$ (not $\\ldots$ or $\\cdots$)

텍스트 강조 시 *이탤릭체* 사용 (볼드체 아님).

가능한 한 텍스트 내에서 '작은 따옴표' 사용.

\#| code-fold: false

주석 기호 뒤에 공백과 대문자:

# This is a comment

인용
@Brockwell:Davis:2002
또는
[@Brockwell:Davis:2002]
또는
[@Rebane:Pearl:1987;@Pearl:2009]

고전적인 분해식을 상기하면
$$Y_t = M_t + S_t + \epsilon_t,$${\#eq-trseas}

모델 @eq-trseas은 다음과 같습니다

[Riksbank Prize](https://www.nobelprize.org/prizes/economic-sciences/2003/engle/facts/)

-----

## 그림

fig-height
행당 1-2개 플롯에 기본값(5) 사용
\#| fig-height: 3 행당 3개 플롯용
\#| fig-height: 7 분해 또는 2행용
\#| fig-height: 9 3행용

```{r}
#| label: fig-shampoo
#| fig-cap: "3년간의 월별 샴푸 판매량 및 해당 표본 ACF."

p1 <- forecast::autoplot(shampoo) +
    xlab("연도") +
    ylab("판매량") +
    theme_light()
p2 <- forecast::ggAcf(shampoo) +
    ggtitle("") +
    xlab("지연 (개월)") +
    theme_light()
p1 + p2 +
    plot_annotation(tag_levels = 'A') &
    theme_light()
```

-----

## 참고 및 예시

::: {.callout-note}
텍스트
:::

::: {.callout-note icon=false}

## 예시: Secchi

텍스트
:::

-----

## 테이블 수동 형식

| 0부터 $d\_{L}$까지 | $d\_{L}$부터 $d\_{U}$까지 | $d\_{U}$부터 $4 - d\_{U}$까지 | $4 - d\_{U}$부터 $4 - d\_{L}$까지 | $4 - d\_{L}$부터 4까지 |
|------|------|------|------|------|
| $H\_{0}$ 기각, 양의 자기상관 | $H\_{1}$ 채택도, $H\_{0}$ 기각도 아님 | $H\_{0}$ 기각하지 않음 | $H\_{1}$ 채택도, $H\_{0}$ 기각도 아님 | $H\_{0}$ 기각, 음의 자기상관 |

: Durbin--Watson 검정을 위한 귀무가설 기각 영역 {\#tbl-DW}

-----

모두 접기 — Alt+O.
모두 펼치기 — Shift+Alt+O.
