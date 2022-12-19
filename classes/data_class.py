import pandas as pd 
import plotly.express as px
import plotly.graph_objects as go
from classes.util import init_connect
from classes.util import colour_list


def display_month_sales():
    #calling a stored procedure in ms sql server to display monthly sales
    df=pd.read_sql_query('execute select_monthly_sales',init_connect())
    fig=px.bar(df,x='Month_Name',y='Total',
    title='Adventure Works Monthly Sales ',
    color='Month_Name',
    color_discrete_sequence=colour_list,
    labels={'Month_Name':'Month','Total':'Sales'})
    fig.update_layout(showlegend=False)
    return df, fig


#calling a stored procedure in ms sql server to display week day sales
# from adventure works sample database
def display_weekday_sales():

    df=pd.read_sql_query('execute select_weekday_sales',init_connect())
    fig=px.line(df,x='WeekDay',y='Total',
    title='Adventure Works Week Day Sales ',
    color='Year',
    #color_discrete_sequence=colour_list,
    labels={'WeekDay':'Day','Total':'Sales'})
    #fig.update_layout(showlegend=False)
    return df, fig

#weekly sales
def display_weekly_sales():

    df=pd.read_sql_query('execute select_weekly_sales',init_connect())
    fig=px.line(df,x='Week',y='Total',
    title='Adventure Works Weekly Sales ',
    color='Year',
    #color_discrete_sequence=colour_list,
    labels={'Week':'Week','Total':'Sales'})
    #fig.update_layout(showlegend=False)
    return df, fig

#quarterly sales
def display_quarterly_sales():

    df=pd.read_sql_query('execute select_quarterly_sales',init_connect())
    fig=px.bar(df,x='Quarter',y='Total',
    title='Adventure Works Quarterly Sales ',
    color='Quarter',
    color_discrete_sequence=colour_list,
    labels={'Total':'Sales'})
    fig.update_layout(showlegend=False)
    return df, fig

#annual sales
def display_annual_sales():

    df=pd.read_sql_query('execute select_annual_sales',init_connect())
    fig=px.bar(df,x='Year',y='Total',
    title='Adventure Works Annual Sales ',
    color='Year',
    color_discrete_sequence=colour_list,
    labels={'Total':'Sales'})
    fig.update_layout(showlegend=False)
    return df, fig

def display_top_performing_products(top,year):

    df=pd.read_sql_query(f'execute select_top_selling_products {top},{year}',init_connect())
    fig=px.bar(df,x='Product',y='Total',
    title=f'Adventure Works Top {top} Product Sales for {year}',
    #color='Product',
    #color_discrete_sequence=colour_list,
    labels={'Total':'Sales'})
    fig.update_layout(showlegend=False)
    return df, fig


def display_sales_by_territory(year):

    df=pd.read_sql_query(f'execute select_territory_sales {year}',init_connect())
    fig=px.bar(df,x='Territory',y='Sales',
    title='Adventure Works Sales By Territories',
    color='Month',
    #color_discrete_sequence=colour_list,
    #labels={'Total':'Sales'}
    )
    fig.update_layout(showlegend=False)
    return df, fig
#get sales by region
def display_sales_by_region(year):

    df=pd.read_sql_query(f'execute select_regional_sales {year}',init_connect())
    fig=px.bar(df,x='RegionName',y='Sales',
    title=f'Adventure Works Sales By Region for {year}',
    color='Month',
    #color_discrete_sequence=colour_list,
    #labels={'Total':'Sales'}
    )
    fig.update_layout(showlegend=False)
    return df, fig


#get sales by region (map)
def display_sales_by_region_map(year):
    
    df=pd.read_sql_query(f'execute select_regional_sales {year}',init_connect())
    country_map = dict(type='choropleth',
           locations=df['RegionName'],
           locationmode='country names',
           z=df['Sales'],
           reversescale = True,
           text=df['RegionName'],
           colorscale='earth',
           colorbar={'title':'Sales'})
    layout = dict(title= f'Sales Distribution over Countries for {year}',
             geo=dict(showframe=False,projection={'type':'mercator'}))
    fig = go.Figure(data = [country_map],layout = layout)
    return df,fig


def display_distinct_products():
    
    df=pd.read_sql_query(f'execute select_products',init_connect())
    
    return df

