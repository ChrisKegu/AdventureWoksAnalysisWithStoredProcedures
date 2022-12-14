import streamlit as st 
import os
from millify import millify# humanise numbers, make it mre readable for humans

#importing methods
from classes.profits import display_annual_profit
from classes.profits import display_monthly_profit
from classes.profits import display_quaterly_profit
from classes.profits import display_aggregated_profit
from classes.profits import display_weekly_profits
from classes.profits import display_weekday_profits

css_path=os.path.join('static','style.css')

with open(css_path) as css:
    st.markdown(f'<style>{css.read()}</style>', unsafe_allow_html=True)
    data=display_aggregated_profit()
total_profit=data['Total Profit'][0]
average_profit=data['Average Profit'][0]
max_profit=data['Max Profit'][0]
min_profit=data['Min Profit'][0]
#display profit values using metrices
col1, col2, col3,col4 = st.columns(4)
col1.write('Total Profit \nMade')
col1.metric('', millify(total_profit,2),millify(total_profit,2) )
col2.write('Profit Per Order ')
col2.metric('', millify(average_profit,2),millify(average_profit,2) )
col3.write('Maximum Profi \n Made')
col3.metric('', millify(max_profit,2),millify(max_profit,2) )
col4.write('Maximum Lost\n Made')
col4.metric('',millify(min_profit,2),millify(min_profit,2) )


tabs=['Week Day','Weekly',
    'Monthly','Quarterly',
    'Annual','Territorial','Regional']
tab1, tab2, tab3,tab4,tab5,tab6,tab7 = st.tabs(tabs)
#display annual profit as bar graph or table
with tab5:
    result,fig=display_annual_profit()
    visual_display=st.radio('tab5Display',('Bar Graph','Table'),
    label_visibility='hidden',horizontal=True)
    if visual_display=='Bar Graph':
        st.plotly_chart(fig)
    elif visual_display=='Table':
        st.dataframe(result,use_container_width=True)
 #display monthly profit       
with tab3:
    result,fig=display_monthly_profit()
    visual_display=st.radio('tab3Display',('Bar Graph','Table'),
    label_visibility='hidden',horizontal=True)
    if visual_display=='Bar Graph':
        st.plotly_chart(fig)
    elif visual_display=='Table':
        result=result[['Month','Year','Profit','PreviousMonthProfit']]
        st.dataframe(result,use_container_width=True)
with tab4:
    result,fig=display_quaterly_profit()
    visual_display=st.radio('tab4Display',('Line Graph','Table'),
    label_visibility='hidden',horizontal=True)
    if visual_display=='Line Graph':
        st.plotly_chart(fig)
    elif visual_display=='Table':
        result=result[['Quarter','Profit']]
        st.dataframe(result,use_container_width=True)
with tab2:
    result,fig=display_weekly_profits()
    visual_display=st.radio('tab2Display',('Line Graph','Table'),
    label_visibility='hidden',horizontal=True)
    if visual_display=='Line Graph':
        st.plotly_chart(fig)
    elif visual_display=='Table':
        result=result[['Week','Month','Year','Total Profit']]
        st.dataframe(result,use_container_width=True)

with tab1:
    #week day profits
    result,fig=display_weekday_profits()
    display=st.radio('tab1Display Type',('Line','Table'),horizontal=True,label_visibility='hidden')

    if display=='Line':
        #display bar chart
        st.plotly_chart(fig)
    elif display=='Table':
        result=result[['WeekDay','Year','Total Profit']]
        st.dataframe(result,use_container_width=True)
    with st.expander("See narations"):
        text="""Monday is an interesting day. Losses were made on Mondays in 2012
        but had the highest profit in 2013. """
        st.write(text)
