import folklore.measure_theory 
noncomputable theory
open set real_axiom.extended_real

namespace Birkhoff_G_ErgodicTheorem

variables {X : Type} (σ : set (set X)) [sigma_algebra σ] (μ : set X → ℝ∞) [hms : measure_space σ μ]

@[meta_data {description := "A transformation is measure preserving if the measure of the image of every set is equal to the measure of the set."}]
def measure_preserving (T : X → X) := ∀ s ∈ σ, μ (image T s) = μ s

def {u} function.pow {α : Type u} (f : α → α) : ℕ → (α → α)
| 0 := id
| (n+1) := f ∘ (function.pow n)

def {u} nth_preimage {α : Type u} (f : α → α) : ℕ → (set α → set α)
| 0 := id
| (n+1) := λ s, {a | f a ∈ nth_preimage n s}

variable (T : X → X)

@[meta_data {description := "A transformation is ergodic if the only sets that map to themselves are null or conull."}]
def ergodic [finite_measure_space σ μ] := ∀ E ∈ σ, nth_preimage T 1 E = E → μ E = 0 ∨ μ E = of_real (univ_measure σ μ)

variables (f : X → ℝ) [lebesgue_integrable σ μ f]

include hms
def time_average_partial (x : X) : ℕ → ℝ :=
(λ n, (1/n)*((((list.iota n).map (λ k, f (function.pow T k x)))).foldr (+) 0))

def time_average_exists (x : X) : Prop :=
nat_limit_at_infinity_exists (time_average_partial σ μ T f x)

@[meta_data {description := "The time average of f under T at x is the limit of (1/n)*Σ{k=1...n} f(T^k(x)) as n→∞"}]
def time_average (x : X) : ℝ := 
nat_limit_at_infinity (time_average_partial σ μ T f x)
omit hms

@[meta_data {description := "The space average of f is (1/μ(univ))*∫f dμ"}]
def space_average [finite_measure_space σ μ] [lebesgue_integrable σ μ f] := (1/univ_measure σ μ)*lebesgue_integral σ μ f


unfinished Birkhoffs_ergodic_theorem :
    ∀ {X} {σ : set (set X)} {μ} [sigma_algebra σ] [finite_measure_space σ μ],
    ∀ (f : X → ℝ) [lebesgue_integrable σ μ f], 
    ∀ {T : X → X} (t_mp : measure_preserving σ μ T) (t_erg : ergodic σ μ T),
         almost_everywhere σ μ (λ x : X, time_average_exists σ μ T f x ∧ time_average σ μ T f x = space_average σ μ f) :=
{description := "Birkhoff's ergodic theorem."}

def furstenberg_source : document :=
{ authors := [{name := "Harry Furstenberg"}],
  title   := "Recurrence in Ergodic Theory",
  year    := ↑1981,
  doi     := "10.1515/9781400855162.59"}

def fabstract : fabstract := 
{ description  := "Birkhoff's ergodic theorem states that, under appropriate conditions, the space average of an integrable function f is equal to the time average of f wrt a measure preserting transformation T. This result was proved in a slightly different form by Birkhoff (1931), and stated and proved in this form by many others, including Halmos (1960) and Furstenberg (1981).",
  contributors := [{name := "Robert Y. Lewis", homepage := "https://andrew.cmu.edu/user/rlewis1"}],
  sources      := [cite.Document furstenberg_source],
  results      := [result.Proof @Birkhoffs_ergodic_theorem] }


end  Birkhoff_G_ErgodicTheorem
