import pandas as pd 
import plotly.express as px
import plotly.graph_objects as go
from classes.util import init_connect
from classes.util import colour_list

def display_annual_profit():

    df=pd.read_sql_query(f'execute select_annual_profits',init_connect())
    fig=px.bar(df,x='Year',y='Profit',
    title=f'Adventure Works Annual Profits',
    color='Year',
    #color_discrete_sequence=colour_list,
    #labels={'Total':'Sales'}
    )
    fig.update_layout(showlegend=False)
    return df, fig

def display_monthly_profit():

    df=pd.read_sql_query(f'execute select_monthly_profits',init_connect())
    df['PreviousMonthProfit']=df['Profit'].shift(1)

    fig=px.bar(df,x='Month',y=['Profit'],
    title=f'Adventure Works Monthly Profits',
    #hover_data=['Month'],
    color='Year',
    #color_discrete_sequence=colour_list,
    labels={'value':'Profit'}
    )
    #fig.update_layout(showlegend=False)
    #fig.update_layout(barmode='group')
  

    return df,fig
   


def display_quaterly_profit():

    df=pd.read_sql_query(f'execute select_quarterly_Sales_profits',init_connect())
    fig=px.bar(df,x='Quarter',y='Profit',
    title=f'Adventure Works Quarterly Profits',
    #color='Year',
    #color_discrete_sequence=colour_list,
    #labels={'Total':'Sales'}
    )
    #fig.update_layout(showlegend=False)
    return df, fig

def display_aggregated_profit():

    df=pd.read_sql_query(f'execute selecte_aggregated_profit',init_connect())
    return df
