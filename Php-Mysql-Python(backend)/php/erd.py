from graphviz import Digraph

# Create a new ER diagram
er = Digraph('ER Diagram', filename='er_diagram_voting_app', format='png')
er.attr(rankdir='LR', size='10')

# Entities
er.node('Voter', shape='rectangle', style='filled', fillcolor='lightblue', label='Voter\n(voter_id, name, aadhaar_number, voter_photo, contact)')
er.node('Candidate', shape='rectangle', style='filled', fillcolor='lightgreen', label='Candidate\n(candidate_id, name, position, party, total_votes)')
er.node('Vote', shape='rectangle', style='filled', fillcolor='lightyellow', label='Vote\n(vote_id, voter_id, candidate_id, timestamp)')
er.node('Admin', shape='rectangle', style='filled', fillcolor='lightcoral', label='Admin\n(admin_id, username, password)')
er.node('Face Recognition Log', shape='rectangle', style='filled', fillcolor='lightgrey', label='Face Recognition Log\n(log_id, voter_id, match_status, timestamp)')

# Relationships
er.edge('Voter', 'Vote', label='casts', color='blue')
er.edge('Vote', 'Candidate', label='for', color='blue')
er.edge('Voter', 'Face Recognition Log', label='verified by', color='red')
er.edge('Admin', 'Voter', label='manages', color='purple')

# Render the ER diagram
er_path = "/mnt/data/er_diagram_voting_app.png"
er.render(er_path, format='png', cleanup=True)
er_path
