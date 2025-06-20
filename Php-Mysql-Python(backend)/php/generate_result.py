
import mysql.connector
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os

# ✅ Connect to MySQL
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="surevote"
)
cursor = conn.cursor()

# ✅ Fetch voting data with proper table name
query = """
SELECT 
    cat.category_id, cat.category_name, 
    pos.id AS position_id, pos.position_name,  -- 🔹 Changed pos.position_id to pos.id
    can.id AS candidate_id, can.candidate_name, 
    can.party_name, can.candidate_symbol_image_path, 
     COUNT(v.id) AS votes 
FROM candidates can
JOIN positions pos ON can.position_id = pos.id  -- 🔹 Ensure correct join
JOIN categories cat ON pos.category_id = cat.category_id
LEFT JOIN votes v ON can.id = v.candidate_id
GROUP BY cat.category_id, cat.category_name, pos.id, pos.position_name, can.id, can.candidate_name, can.party_name, can.candidate_symbol_image_path
ORDER BY cat.category_name, pos.position_name, votes DESC;
"""

df = pd.read_sql_query(query, conn)
conn.close()

# ✅ Save results to MySQL for PHP & Flutter
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="surevote"
)
cursor = conn.cursor()

# ✅ Create table if not exists
# cursor.execute("""
# CREATE TABLE IF NOT EXISTS voting_results (
#     id INT AUTO_INCREMENT PRIMARY KEY,
#     category_id INT,
#     position_id INT,
#     candidate_id INT,
#     votes INT DEFAULT 0,
#     FOREIGN KEY (category_id) REFERENCES categories(category_id),
#     FOREIGN KEY (position_id) REFERENCES positions(position_id),
#     FOREIGN KEY (candidate_id) REFERENCES candidates(id)
# )
#""")

# ✅ Update existing votes instead of deleting
insert_query = """
    INSERT INTO voting_results (category_id, position_id, candidate_id, votes) 
    VALUES (%s, %s, %s, %s)
    ON DUPLICATE KEY UPDATE votes = VALUES(votes);
"""
data_to_insert = [(row["category_id"], row["position_id"], row["candidate_id"], row["votes"]) for _, row in df.iterrows()]
cursor.executemany(insert_query, data_to_insert)

conn.commit()
conn.close()

# ✅ Ensure the output directory exists
output_dir = "/var/www/html/voting_results/"
if not os.path.exists(output_dir):
    os.makedirs(output_dir, exist_ok=True)

# # ✅ Generate Charts
categories = df["category_name"].unique()
for category in categories:
    category_df = df[df["category_name"] == category]
    positions = category_df["position_name"].unique()

    for position in positions:
        position_df = category_df[category_df["position_name"] == position]

        plt.figure(figsize=(8, 5))
        colors = plt.cm.get_cmap("tab10")(np.arange(len(position_df)))  # Controlled colors
        plt.bar(position_df["candidate_name"], position_df["votes"], color=colors)
        plt.xlabel("Candidates")
        plt.ylabel("Votes")
        plt.title(f"{category} - {position} Results")
        plt.xticks(rotation=30)
        plt.grid(axis='y', linestyle='--', alpha=0.7)  # Better grid visibility

        file_path = os.path.join(output_dir, f"{category}_{position}.png")
        plt.savefig(file_path, dpi=300)  # Save with higher resolution
        plt.close()

print("Results updated successfully.")














# import mysql.connector
# import pandas as pd
# import numpy as np
# import matplotlib.pyplot as plt
# import os

# # ✅ Connect to MySQL
# conn = mysql.connector.connect(
#     host="localhost",
#     user="root",
#     password="",
#     database="surevote"
# )
# cursor = conn.cursor()

# # ✅ Fetch voting data (Ensure IDs are fetched)
# query = """
# SELECT 
#     cat.category_id, cat.category_name, 
#     pos.position_id, pos.position, 
#     can.id AS candidate_id, can.candidate_name, 
#     can.party_name, can.symbol_img_path, 
#     COUNT(*) AS votes
# FROM candidate can
# JOIN positions pos ON can.position_id = pos.position_id
# JOIN categories cat ON pos.category_id = cat.category_id
# GROUP BY cat.category_id, cat.category_name, pos.position_id, pos.position, can.id, can.candidate_name, can.party_name, can.symbol_img_path
# ORDER BY cat.category_name, pos.position, votes DESC;
# """

# df = pd.read_sql_query(query, conn)
# conn.close()

# # ✅ Save results to MySQL for PHP & Flutter
# conn = mysql.connector.connect(
#     host="localhost",
#     user="root",
#     password="",
#     database="surevote"
# )
# cursor = conn.cursor()

# # ✅ Create table for results
# # cursor.execute("""
# # CREATE TABLE IF NOT EXISTS voting_results (
# #     id INT AUTO_INCREMENT PRIMARY KEY,
# #     category_id INT,
# #     position_id INT,
# #     candidate_id INT,
# #     votes INT DEFAULT 0,
# #     FOREIGN KEY (category_id) REFERENCES categories(category_id),
# #     FOREIGN KEY (position_id) REFERENCES positions(id),
# #     FOREIGN KEY (candidate_id) REFERENCES candidates(id)
# # )
# # """)

# # # ✅ Clear old results and insert new ones
# # cursor.execute("DELETE FROM voting_results")
# insert_query = """
#     INSERT INTO voting_results (category_id, position_id, candidate_id, votes) 
#     VALUES (%s, %s, %s, %s)
# """
# data_to_insert = [(row["category_id"], row["position_id"], row["candidate_id"], row["votes"]) for _, row in df.iterrows()]
# cursor.executemany(insert_query, data_to_insert)

# conn.commit()
# conn.close()

# # ✅ Ensure the directory exists
# output_dir = "/var/www/html/voting_results/"
# os.makedirs(output_dir, exist_ok=True)

# # ✅ Generate Charts
# categories = df["category_name"].unique()
# for category in categories:
#     category_df = df[df["category_name"] == category]
#     positions = category_df["position"].unique()

#     for position in positions:
#         position_df = category_df[category_df["position"] == position]

#         plt.figure(figsize=(8, 5))
#         colors = plt.cm.get_cmap("tab10")(np.arange(len(position_df)))  # ✅ Controlled colors
#         plt.bar(position_df["candidate_name"], position_df["votes"], color=colors)
#         plt.xlabel("Candidates")
#         plt.ylabel("Votes")
#         plt.title(f"{category} - {position} Results")
#         plt.xticks(rotation=30)
#         plt.grid(axis='y', linestyle='--', alpha=0.7)  # ✅ Added grid for better visibility

#         file_path = os.path.join(output_dir, f"{category}_{position}.png")
#         plt.savefig(file_path, dpi=300)  # ✅ Save with higher resolution for clarity
#         plt.close()

# print("Results updated successfully.")
