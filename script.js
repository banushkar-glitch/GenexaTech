/* =========================================================
   GENEXA TECH
   MAIN JAVASCRIPT
   ========================================================= */

   document.addEventListener("DOMContentLoaded", () => {

    /* =====================================================
       MOBILE NAVIGATION
       ===================================================== */

    const mobileMenuButton =
        document.getElementById("mobileMenuButton");

    const mobileNav =
        document.getElementById("mobileNav");


    if (mobileMenuButton && mobileNav) {

        mobileMenuButton.addEventListener("click", () => {

            const isOpen =
                mobileNav.classList.toggle("open");


            mobileMenuButton.setAttribute(
                "aria-expanded",
                isOpen
            );


            mobileMenuButton.innerHTML = isOpen
                ? '<i class="fa-solid fa-xmark"></i>'
                : '<i class="fa-solid fa-bars"></i>';

        });


        /* Close mobile menu after selecting a section */

        mobileNav.querySelectorAll("a").forEach(link => {

            link.addEventListener("click", () => {

                mobileNav.classList.remove("open");

                mobileMenuButton.setAttribute(
                    "aria-expanded",
                    "false"
                );

                mobileMenuButton.innerHTML =
                    '<i class="fa-solid fa-bars"></i>';

            });

        });

    }

        /* =====================================================
       PORTFOLIO CAROUSEL
       ===================================================== */

       const portfolioSlider =
       document.getElementById("portfolioSlider");

   const prevBtn =
       document.getElementById("prevBtn");

   const nextBtn =
       document.getElementById("nextBtn");


   if (
       portfolioSlider &&
       prevBtn &&
       nextBtn
   ) {

       const getScrollAmount = () => {

           const card =
               portfolioSlider.querySelector(
                   ".portfolio-card"
               );

           if (!card) {
               return 380;
           }

           const cardWidth =
               card.getBoundingClientRect().width;

           const gap = 24;

           return cardWidth + gap;
       };


       prevBtn.addEventListener("click", () => {

           portfolioSlider.scrollBy({
               left: -getScrollAmount(),
               behavior: "smooth"
           });

       });


       nextBtn.addEventListener("click", () => {

           portfolioSlider.scrollBy({
               left: getScrollAmount(),
               behavior: "smooth"
           });

       });

   }

       /* =====================================================
       FAQ ACCORDION
       ===================================================== */

       const faqQuestions =
       document.querySelectorAll(".faq-question");


   faqQuestions.forEach(question => {

       question.addEventListener("click", () => {

           const currentItem =
               question.closest(".faq-item");

           const isCurrentlyOpen =
               currentItem.classList.contains("active");


           /* Close all FAQ items */

           document
               .querySelectorAll(".faq-item")
               .forEach(item => {

                   item.classList.remove("active");

                   const button =
                       item.querySelector(".faq-question");

                   if (button) {
                       button.setAttribute(
                           "aria-expanded",
                           "false"
                       );
                   }

               });


           /* Open clicked item if it was closed */

           if (!isCurrentlyOpen) {

               currentItem.classList.add("active");

               question.setAttribute(
                   "aria-expanded",
                   "true"
               );

           }

       });

   });

});