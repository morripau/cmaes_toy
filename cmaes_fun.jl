### A Pluto.jl notebook ###
# v0.20.8

using Markdown
using InteractiveUtils

# ╔═╡ c168da40-3b42-11f0-3ff4-fb809b3e9890
begin
	import Pkg; Pkg.activate()
	using CairoMakie, Distributions, ColorSchemes, LinearAlgebra
end

# ╔═╡ 299ec06e-de8c-46cf-8ac2-bc21587f3870
function obj_fun(x)
	x₁, x₂ = x
	fₓ = 0.26 * (x₁^2 + x₂^2) - 0.48 * x₁ * x₂
	return fₓ
end

# ╔═╡ fb6f0cdd-729e-4a1b-a185-6c50aa154bf3
begin
	x_lb = [-1.0, -1.0]
	x_ub = [3.0, 3.0]
end

# ╔═╡ 81fd1d45-2673-4f03-8421-ad5ecab06a76
function gen_candidates(Σ, x; n=10)
	dist = MvNormal(x, Σ)
	return [rand(dist) for i=1:n]
end

# ╔═╡ d9fb250a-23e8-43d2-a17e-72b5c18fabda
begin
	Σ = I(2)
	x̄ = [1, 1]
	candidates = gen_candidates(Σ, x̄)
end

# ╔═╡ 7fd813a7-26b9-4612-8dd4-d6d7e455781c
function fit_candidates(candidates)
	fitness = [obj_fun(can) for can in candidates]
	keepers = sortperm(fitness)[1:5]

	new_x̄ = mean(candidates[keepers])
	new_Σ = cov(candidates[keepers], candidates[keepers])

	new_candidates = gen_candidates(new_Σ, new_x̄)
	return new_candidates
end

# ╔═╡ 06cf0bd2-df04-43c9-9364-4af385728bf3
new_candidates = fit_candidates(candidates)

# ╔═╡ 043e7111-456e-4a7c-9ba1-2c532bb4cf71
new_candidates_2 = fit_candidates(new_candidates)

# ╔═╡ 95210c6e-bb3c-4502-b7a2-ba361e5c72e2
new_candidates_3 = fit_candidates(new_candidates_2)

# ╔═╡ de7349fe-cdcf-40f0-b37b-d6a351aa81ef
begin
	x₁s = range(x_lb[1], x_ub[1], length=100)
	x₂s = range(x_lb[2], x_ub[2], length=100)
	fig, ax, hm = heatmap(x₁s, x₂s, [obj_fun([x₁, x₂]) for x₁ in x₁s, x₂ in x₂s], colormap=ColorSchemes.viridis)
	Colorbar(fig[:, end+1], hm)
	scatter!(ax,[can[1] for can in new_candidates_3], [can[2] for can in new_candidates_3], color=:white)
	fig
end

# ╔═╡ Cell order:
# ╠═c168da40-3b42-11f0-3ff4-fb809b3e9890
# ╠═299ec06e-de8c-46cf-8ac2-bc21587f3870
# ╠═fb6f0cdd-729e-4a1b-a185-6c50aa154bf3
# ╠═de7349fe-cdcf-40f0-b37b-d6a351aa81ef
# ╠═81fd1d45-2673-4f03-8421-ad5ecab06a76
# ╠═d9fb250a-23e8-43d2-a17e-72b5c18fabda
# ╠═7fd813a7-26b9-4612-8dd4-d6d7e455781c
# ╠═06cf0bd2-df04-43c9-9364-4af385728bf3
# ╠═043e7111-456e-4a7c-9ba1-2c532bb4cf71
# ╠═95210c6e-bb3c-4502-b7a2-ba361e5c72e2
