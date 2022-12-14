import streamlit as st 
from classes.data_class import display_top_performing_products

tabs=['Best Sellers','Customer']
tab1,tab2=st.tabs(tabs)
with tab1:
    with st.container():
        col1,col2,col3=st.columns(3)
        with col1:

            number_of_products=st.text_input('Enter Number of Products to Display',
             #place_holder='Please enter the number of products to display here'
            )
        with col2:

            year=st.text_input('Enter Year',
            #place_holder='Please enter year hear'
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
            result=result[['Product','Month','Year','Total']]
            st.dataframe(result,use_container_width=True)
#tab 1 ends here