import streamlit as st 
from millify import millify
from classes.data_class import display_top_performing_products
from classes.data_class import display_sales_by_territory
from classes.data_class import display_quarterly_sales

tabs=['Best Sellers','Customer']
tab1,tab2=st.tabs(tabs)
with tab1:
    with st.container():
        col1,col2,col3=st.columns(3)
        with col1:

            number_of_products=st.text_input('Number of Products',
             placeholder='Enter the number of products'
            )
        with col2:

            year=st.text_input('Enter Year',
            placeholder='Please enter year hear'
            )
        with col3:
            st.markdown('')
            st.markdown('')
            submit=st.button('Display')

    if number_of_products=='' or number_of_products==None:
        pass
    elif year=='' or year== None:
        pass
    else:
        year=int(year)
        number_of_products=int(number_of_products)
        result, fig=display_top_performing_products(number_of_products,year)
        visual_display=st.radio('topDisplay',('Bar','Tabular'),
        label_visibility='hidden',horizontal=True)
        if visual_display=='Bar':
            st.plotly_chart(fig)
        elif visual_display=='Tabular':
            #millify total
            result[['Total']]=result[['Total']].applymap(millify)
            result=result[['Product','Month','Year','Total']]
            st.dataframe(result,use_container_width=True)
#tab 1 ends here

with tab2:
    
    with st.container():
        col11, col12 = st.columns(2)
        result, fig=display_quarterly_sales()
        tresult,tfig=display_sales_by_territory(2011)
        col11.plotly_chart(fig)
        col12.plotly_chart(tfig)
    
    with st.container():
        col21, col22 = st.columns(2)
        result, fig=display_quarterly_sales()
        tresult,tfig=display_sales_by_territory(2011)
        col21.plotly_chart(fig)
        col22.plotly_chart(tfig)

