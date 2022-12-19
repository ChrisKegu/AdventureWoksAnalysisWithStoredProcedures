import streamlit as st 
import plotly.express as px
from datetime import date
from classes.data_class import display_month_sales
from classes.data_class import display_weekday_sales
from classes.data_class import display_weekly_sales
from classes.data_class import display_quarterly_sales 
from classes.data_class import display_annual_sales
from classes.data_class import display_sales_by_territory
from classes.data_class import display_sales_by_region
from classes.data_class import display_sales_by_region_map
from classes.profits import display_time_series_profits
from classes.data_class import display_distinct_products

tabs=['Week Day','Weekly',
    'Monthly','Quarterly',
    'Annual','Territorial','Regional','Time Series']
tab1, tab2, tab3,tab4,tab5,tab6,tab7,tab8 = st.tabs(tabs)


with tab1:
    result,fig=display_weekday_sales()
    tab2_display=st.radio('tab1Display Type',('Line','Tabular'),horizontal=True,label_visibility='hidden')

    if tab2_display=='Line':
        #display bar chart
        st.plotly_chart(fig)
    elif tab2_display=='Tabular':
        result=result[['WeekDay','Year','Total']]
        st.dataframe(result,use_container_width=True)
## week day tab ends here

with tab2:
    result,fig=display_weekly_sales()
    display=st.radio('tab2Display Type',('Line','Tabular'),horizontal=True,label_visibility='hidden')

    if display=='Line':
        #display bar chart
        st.plotly_chart(fig)
    elif display=='Tabular':
        result=result[['Week','Month','Year','Total']]
        st.dataframe(result,use_container_width=True)
with tab3:
    #monthly sales
    result,fig=display_month_sales()
    display=st.radio('tab3Display Type',('Bar','Tabular'),horizontal=True,label_visibility='hidden')

    if display=='Bar':
        #display bar chart
        st.plotly_chart(fig)
    elif display=='Tabular':
        result=result[['Month_Name','Total']]
        st.dataframe(result,use_container_width=True)
with tab4:
    #quarterly sales
    result,fig=display_quarterly_sales()
    display=st.radio('tab4Display Type',('Bar','Tabular'),horizontal=True,label_visibility='hidden')

    if display=='Bar':
        #display bar chart
        st.plotly_chart(fig)
    elif display=='Tabular':
        result=result[['Quarter','Total']]
        st.dataframe(result,use_container_width=True)
with tab5:
    #annual sales
    
    display=st.radio('tab5Display Type',('Bar','Tabular'),horizontal=True,label_visibility='hidden')
    result,fig=display_annual_sales()
    if display=='Bar':
        #display bar chart
        st.plotly_chart(fig)
    elif display=='Tabular':
        result=result[['Year','Total']]
        st.dataframe(result,use_container_width=True)
with tab6:
    #territorial sales
    
    col11,col21=st.columns(2)
    with col11:
        year=st.text_input('Year',
        placeholder='Enter year you want to view here')
    with col21:
        st.markdown('')
        st.markdown('')
        button=st.button('Display')
    if year=='' or year ==None:
        pass
    else:
        year=int(year)
        fig=None
        result=None
        result,fig=display_sales_by_territory(year)
        display=st.radio('tab6Display Type',('Bar','Tabular'),horizontal=True,label_visibility='hidden')

        if display=='Bar':
        #display bar chart
            st.plotly_chart(fig)
        elif display=='Tabular':
            result=result[['Month','Year','Territory','Sales']]
            st.dataframe(result,use_container_width=True)
with tab7:
     
    col12,col22=st.columns(2)
    with col12:
        year=st.text_input('Year',key='region_year',
        placeholder='Enter year you want to view here')
    with col22:
        st.markdown('')
        st.markdown('')
        button=st.button('Display',key='region_button')
    if year=='' or year ==None:
        pass
    else:
        year=int(year)
        fig=None
        result=None
        result,fig=display_sales_by_region(year)
        display=st.radio('tab7Display Type',('Bar','Tabular','Map'),horizontal=True,label_visibility='hidden')

        if display=='Bar':
        #display bar chart
            st.plotly_chart(fig)
        elif display=='Tabular':
            result=result[['Month','Year','RegionName','Sales']]
            st.dataframe(result,use_container_width=True)
        elif display=='Map':
            result,fig=display_sales_by_region_map(year)
            st.plotly_chart(fig)
with tab8:
    with st.form(key='loan_form',clear_on_submit=True):
        with st.container():
            product_list=display_distinct_products()
            products=st.multiselect('Select Product',product_list)
        with st.container():
            tab8col1,tab8col2,tab8col3=st.columns(3)
            
            min_val=date(2000,1,1)
            max_val=date.today()
            
            startdate=tab8col1.date_input('Start Date',min_value=min_val,max_value=max_val)
            enddate=tab8col2.date_input('End Date',max_value=max_val)
            
            tab8col3.markdown('')
            tab8col3.markdown('')
            submit_button=tab8col3.form_submit_button('Display')

    if submit_button:
        result=display_time_series_profits(startdate,enddate)
        
        if len(result)>0:
            result=result[result['Product'].isin(products)]
            result=result.pivot_table(index='OrderDate',columns='Product',
            values='LineTotal',aggfunc='sum')
            fig=px.line(result,x=result.index,y=result.columns,
            labels={'value':'Sales','OrderDate':'Date'})
            st.plotly_chart(fig)
        else:
            st.subheader(f'No Data found for the period {startdate} and {enddate} for product(s){products}')
    


