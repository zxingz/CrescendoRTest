import sqlite3
import matplotlib.pyplot as plt
from sklearn import linear_model
import numpy as np
from sklearn.tree import DecisionTreeRegressor


def fetch_query_result(query):
    conn = sqlite3.connect('pythonDB.db')
    res = list(conn.execute(query))
    conn.close()
    return res


# 4. A baseball player is said to be continuously playing if he's playing for consequent years. Given the years that some baseball player played in, write the function activeYears which computes the sequence of the lengths of the continuous playing.
def activeYears(years):
    years = list(set(sorted(years)))
    years.append(-1)
    res = []
    counter = 1
    for i in range(len(years)-1):
        if int(years[i])+1 == int(years[i+1]):
            counter += 1
        else:
            res.append(counter)
            counter = 1
    return res


if __name__ == '__main__':
    # 1.Using Lahman MLB data in R, list the top 5 teams since 2000 with the largest stolen bases per at bat ratio:
    query = 'select name, sum(SB), sum(AB) , teamID, yearID from teams where yearID >= 2000  and SB <> "NA" and AB <> "NA" group by name'
    result = fetch_query_result(query)
    result = sorted(result, key=lambda l: l[1]/l[2], reverse=True)
    for i in range(5):
        print(result[i][0])

    #2. Using this same Batting data, plot the yearly SB.Per.AB rate.  This will be computed over the entire year rather than per team-year as above.
    query = 'select yearID, sum(SB)as SB, sum(AB) as AB from Batting where SB <> "NA" and AB <> "NA" group by yearID order by yearID'
    result = fetch_query_result(query)
    x = [l[0] for l in result]
    y = [l[1]/l[2] for l in result]
    plt.figure(1)
    plt.subplot(211)
    plt.plot(x, y, linewidth=2.0)

    #2a.  Same plot but color each plot by lgID (LeagueID).  For this problem we only care about NL and AL, everything else can be filtered out.
    query = 'select yearID, sum(SB)as SB, sum(AB) as AB, lgID from Batting where SB <> "NA" and AB <> "NA" and lgID in ("NL", "AL") group by yearID, lgID order by yearID'
    result = fetch_query_result(query)
    x1 = []
    y1 = []
    x2 = []
    y2 = []
    for row in result:
        if row[3] == "AL":
            x1.append(row[0])
            y1.append(row[1]/row[2])
        elif row[3] == "NL":
            x2.append(row[0])
            y2.append(row[1]/row[2])
    plt.subplot(212)
    plt.plot(x1, y1, linewidth=2.0)
    plt.plot(x2, y2, linewidth=2.0)
    plt.show()

    #3.  Use this Year, SB.PerAB dataset (generated in #2 above) to create a model for how year relates to SB.PerAB.  In this problem you are using only yearID to predict SB.PerAB.  Try a few model fits and determine which one is best.
    query = 'select yearID, sum(SB)as SB, sum(AB) as AB from Batting where SB <> "NA" and AB <> "NA" group by yearID order by yearID'
    result = fetch_query_result(query)
    x_old = [float(l[0]) for l in result]
    y_old = [float(l[1] / l[2]) for l in result]
    x = np.array(x_old)
    y = np.array(y_old)

    model = np.polyfit(x,y,1)
    print("Mean squared error in linear fit: %f" % np.mean((np.polyval(model,x) - y) ** 2))
    model = np.polyfit(x, y, 2)
    print("Mean squared error in polyfit 2: %f" % np.mean((np.polyval(model, x) - y) ** 2))
    model = np.polyfit(x, y, 3)
    print("Mean squared error in polyfit 3: %f" % np.mean((np.polyval(model, x) - y) ** 2))
    regressor = DecisionTreeRegressor(random_state=0)
    regressor.fit(x[:, None],y)
    print("Mean squared error in DecisionTreeRegressor: %f" % np.mean((regressor.predict(x[:, None]) - y) ** 2))
    print('Best method is DecisionTreeRegressor ! ')



    # 4. A baseball player is said to be continuously playing if he's playing for consequent years. Given the years that some baseball player played in, write the function activeYears which computes the sequence of the lengths of the continuous playing.
    print(activeYears((1999,1995,1996,1998,1999,2000,2001,2003,2004,2006)))
