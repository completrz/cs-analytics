import pandas as pd

matches = pd.read_parquet("data/matches.parquet")
rounds = pd.read_parquet("data/rounds.parquet")
kills = pd.read_parquet("data/kills.parquet")
round_player = pd.read_parquet("data/round_player.parquet")

print("MATCHES")
print(matches.head())
print(matches.columns.tolist())
print(matches.shape)

print("\nROUNDS")
print(rounds.head())
print(rounds.columns.tolist())
print(rounds.shape)

print("\nKILLS")
print(kills.head())
print(kills.columns.list())
print(kills.shape)
