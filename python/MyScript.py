import sqlite3


def fetch_query_result(query):
    conn = sqlite3.connect('pythonDB.db')
    res = list(conn.execute(query))
    conn.close()
    return res


if __name__ == '__main__':
    # 1.Using Lahman MLB data in R, list the top 5 teams since 2000 with the largest stolen bases per at bat ratio:
    dict = {}
    query = 'select name, sum(SB), sum(AB) , teamID, yearID from teams where yearID >= 2000  and SB <> "NA" and AB <> "NA" group by name'
    result = fetch_query_result(query)
    result = sorted(result, key=lambda l: l[1]/l[2], reverse=True)
    for i in range(5):
        print(result[i][0])


#this is a test code in python, Main code is written in R