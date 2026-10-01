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
print(kills.columns.tolist())
print(kills.shape)

print("\nROUND PLAYER")
print(round_player.head())
print(round_player.columns.tolist())
print(round_player.shape)
