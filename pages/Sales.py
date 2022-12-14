import streamlit as st 
from classes.data_class import display_month_sales
from classes.data_class import display_weekday_sales
from classes.data_class import display_weekly_sales
from classes.data_class import display_quarterly_sales 
from classes.data_class import display_annual_sales
from classes.data_class import display_sales_by_territory
from classes.data_class import display_sales_by_region
from classes.data_class import display_sales_by_region_map

tabs=['Week Day','Weekly',
    'Monthly','Quarterly',
    'Annual','Territorial','Regional']
tab1, tab2, tab3,tab4,tab5,tab6,tab7 = st.tabs(tabs)


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
